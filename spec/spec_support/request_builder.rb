# frozen_string_literal: true
# This class provides a mechanism for adding header fields in a request
# like authorization headers.

class RequestBuilder
  def initialize(operation)
    @current_operation = operation
  end

  # Identifies if the API has security or not then sends request accordingly
  def send_security_vs_none
    # Get schema of the response
    if @current_operation.verb.to_s != "options"
      schema = @current_operation.responses.values[0].schema.root
      if schema.keys.include?('securityDefinitions')
        # Get the type, name, and in fields of the security
        schema_security = schema.securityDefinitions.values[0]
        # Gets the name of the security to use for authorization
        name = schema_security.name
        user_home_dir = File.expand_path('~')
        # Accesses the file to get the jwt token
        yaml = YAML.load_file(File.join("#{user_home_dir}", 'test_data/QA/jwt_token.yml'))
        token = yaml.fetch('token')
        # Uses the name and token variables bypass security
        RestClient.public_send(@current_operation.verb, @current_operation.url, "#{name}": "#{token}")
      else
        RestClient.public_send(@current_operation.verb, @current_operation.url)
      end
    end
  end
end
