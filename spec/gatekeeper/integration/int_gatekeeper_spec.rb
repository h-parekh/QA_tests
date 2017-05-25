#frozen_string_literal: true
require 'gatekeeper/gatekeeper_spec_helper'

feature 'Gatekeeper API test' do
  SwaggerHandler.operations(for_file_path: __FILE__).each do |operation|
    scenario "calls #{operation.verb} #{operation.path}" do
      request['authorization'] = "Token token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7Im5ldGlkIjoidF9oZXNsaWIwMSJ9fQ.6MDSyPVHwx7ZFtsY6fQww4rj6shLHiqtmMXOCLrD89s"
      result = public_send(operation.verb, operation.url)
      current_response = ResponseValidator.new(operation, result)
      expect(current_response).to be_valid_response
    end
  end
end
