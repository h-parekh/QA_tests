# frozen_string_literal: true
# This class provides a mechanism for adding header fields in a request
# like authorization headers.
require 'csv'

class RequestBuilder
  attr_reader :current_logger, :context

  def initialize(logger, operation, context: nil)
    @current_operation = operation
    @security_name = get_security_name
    @token = get_token
    @current_logger = logger
    @context = context
    apply_parameter_to_parameterized_path!
  end

  # Identifies if the API has security or not then sends request accordingly
  def check_security
    if @current_operation.responses.values[0].schema.nil?
      return false
    else
      schema = @current_operation.responses.values[0].schema.root
      schema.keys.include?('securityDefinitions')
    end
  end

  def apply_parameter_to_parameterized_path!
    @current_operation.path = PathParameterizer.call(
      application_name_under_test: current_logger.application_name_under_test,
      logger: current_logger,
      path: @current_operation.path,
      context: context
    )

    @current_operation.path = PathParameterizer.call_query_parameterizer(
      application_name_under_test: current_logger.application_name_under_test,
      logger: current_logger,
      operation: @current_operation,
      context: context
    )
  end

  def get_token
    # Accesses the file to get the jwt token
    yaml = YAML.load_file(File.join(ENV.fetch('HOME'), 'test_data/QA/jwt_token.yml'))
    yaml.fetch('token')
  end

  def get_security_name
    if check_security
      # Get schema of the response
      schema = @current_operation.responses.values[0].schema.root
      # Get the type, name, and in fields of the security
      schema_security = schema.securityDefinitions.values[0]
      # Gets the name of the security to use for authorization
      schema_security.name
    end
  end

  def send_via_operation_verb(*body)
    # determines which method verb the current opertation has and sends request accordingly
    security = check_security
    case @current_operation.verb.to_s
    when "get"
      current_logger.info(context: "making GET request", url: @current_operation.url)
      require 'byebug'; debugger
      if security
        RestClient.public_send(@current_operation.verb, @current_operation.url, "#{@security_name}": "#{@token}")
      else
        RestClient.public_send(@current_operation.verb, @current_operation.url)
      end
    when "post"
      current_logger.info(context: "making POST request", url: @current_operation.url)
      if security
        RestClient.public_send(@current_operation.verb, @current_operation.url, body, "#{@security_name}": "#{@token}")
      else
        RestClient.public_send(@current_operation.verb, @current_operation.url, body)
      end
    when "put" # might need  specific item when testing
      current_logger.info(context: "making PUT request", url: @current_operation.url)
      if security
        RestClient.public_send(@current_operation.verb, @current_operation.url, body, "#{@security_name}": "#{@token}")
      else
        RestClient.public_send(@current_operation.verb, @current_operation.url, body)
      end
    when "patch" # might need specific item when testing
      current_logger.info(context: "making PATCH request", url: @current_operation.url)
      if security
        RestClient.public_send(@current_operation.verb, @current_operation.url, body, "#{@security_name}": "#{@token}")
      else
        RestClient.public_send(@current_operation.verb, @current_operation.url, body)
      end
    when "delete" # might need specific item when testing
      current_logger.info(context: "making DELETE request", url: @current_operation.url)
      if security
        RestClient.public_send(@current_operation.verb, @current_operation.url, "#{@security_name}": "#{@token}")
      else
        RestClient.public_send(@current_operation.verb, @current_operation.url)
      end
    when "options"
      current_logger.info(context: "OPTIONS method - no request made")
      create_mock_response_for_options
    else
      current_logger.info(context: "Unknown verb - no request made")
    end
  end

  def create_mock_response_for_options
    mock_body = "{message: 'Mocked up body for 'options' method}"
    mock_response = Net::HTTPResponse.new('1.1', '200', 'Mock message')
    mock_request = RestClient::Request.new(url: 'http://example.com', method: :options)
    RestClient::Response.create(mock_body, mock_response, mock_request)
  end
end
