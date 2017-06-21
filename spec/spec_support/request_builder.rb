# frozen_string_literal: true
# This class provides a mechanism for adding header fields in a request
# like authorization headers.
require 'csv'

class RequestBuilder
  attr_reader :current_logger

  def initialize(logger,operation)
    @current_operation = operation
    @security_name = get_security_name
    @token = get_token
    @current_logger = logger
  end

  # Identifies if the API has security or not then sends request accordingly
  def check_security
    schema = @current_operation.responses.values[0].schema.root
    schema.keys.include?('securityDefinitions')
  end

  def get_token
    user_home_dir = File.expand_path('~')
    # Accesses the file to get the jwt token
    yaml = YAML.load_file(File.join("#{user_home_dir}", 'test_data/QA/jwt_token.yml'))
    token = yaml.fetch('token')
  end

  def get_security_name
    if check_security
      # Get schema of the response
      schema = @current_operation.responses.values[0].schema.root
      # Get the type, name, and in fields of the security
      schema_security = schema.securityDefinitions.values[0]
      # Gets the name of the security to use for authorization
      name = schema_security.name
    end
  end

  def send_via_operation_verb(*body)
    # determines which method verb the current opertation has and sends request accordingly
    security = check_security
    case (@current_operation.verb.to_s)
    when "get"
      current_logger.info(context: "making GET request")
      if security
        RestClient.public_send(@current_operation.verb, @current_operation.url, "#{@security_name}": "#{@token}")
      else
        RestClient.public_send(@current_operation.verb, @current_operation.url)
      end
    when "post"
      current_logger.info(context: "making POST request")
      if security
        RestClient.public_send(@current_operation.verb, @current_operation.url, body, "#{@security_name}": "#{@token}")
      else
        RestClient.public_send(@current_operation.verb, @current_operation.url, body)
      end
    when "put" #might need  specific item when testing
      current_logger.info(context: "naking PUT request")
      if security
        RestClient.public_send(@current_operation.verb, @current_operation.url, body, "#{@security_name}": "#{@token}")
      else
        RestClient.public_send(@current_operation.verb, @current_operation.url, body)
      end
    when "patch" #might need specific item when testing
      current_logger.info(context: "making PATCH request")
      if security
        RestClient.public_send(@current_operation.verb, @current_operation.url, body, "#{@security_name}": "#{@token}")
      else
        RestClient.public_send(@current_operation.verb, @current_operation.url, body)
      end
    when "delete" #might need specific item when testing
      current_logger.info(context: "making DELETE request")
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
