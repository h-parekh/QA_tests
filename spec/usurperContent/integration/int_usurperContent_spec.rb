#frozen_string_literal: true
require 'usurperContent/usurperContent_spec_helper'

feature 'API tests for Usurper Content API' do
  SwaggerHandler.operations(for_file_path: __FILE__).each do |operation|
    scenario "calls #{operation.verb} #{operation.path}" do
      schema = RequestBuilder.new(current_logger, operation)
      result = schema.send_via_operation_verb
      current_response = ResponseValidator.new(operation, result)
      expect(current_response).to be_valid_response
    end
  end
end
