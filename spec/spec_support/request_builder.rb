# frozen_string_literal: true
# This class provides a mechanism for adding header fields in a request
# like authorization headers.
require 'csv'

class RequestBuilder
  attr_reader :current_logger

  def initialize(logger, operation)
    @current_operation = operation
    @security_name = get_security_name
    @token = get_token
    @current_logger = logger
    check_for_path_parameter!
  end

  # Identifies if the API has security or not then sends request accordingly
  def check_security
    schema = @current_operation.responses.values[0].schema.root
    schema.keys.include?('securityDefinitions')
  end

  def check_for_path_parameter!
    path_parameter = @current_operation.path.match(/\{(.*)\}/)
    if path_parameter
      current_logger.debug(context: "Operation contains path parameter", path: @current_operation.path)
      sampled_parameter = get_path_parameter!
      @current_operation.path = @current_operation.path.sub(path_parameter[0], sampled_parameter[0])
      current_logger.debug(context: "Path parameter has been updated", path: @current_operation.path)
    else
      current_logger.debug(context: "Operation does not contain a path parameter", path: @current_operation.path)
    end
  end

  def get_path_parameter!
    user_home_dir = File.expand_path('~')
    parameter_list = CSV.read(user_home_dir + "/test_data/QA/aleph_system_ids.csv")
    parameter_list.sample
  end

  def get_token
    user_home_dir = File.expand_path('~')
    # Accesses the file to get the jwt token
    yaml = YAML.load_file(File.join("#{user_home_dir}", 'test_data/QA/jwt_token.yml'))
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
      current_logger.info(context: "naking PUT request", url: @current_operation.url)
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
    else
      current_logger.info(context: "Unknown verb - no request made")
    end
  end
end
