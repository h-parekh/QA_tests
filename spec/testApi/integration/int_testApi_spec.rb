# frozen_string_literal: true
require 'testApi/testApi_spec_helper'

describe 'API tests using swagger definition' do
  ApiConfig.swagger_object.operations.each do |operation|
    it "calls #{operation.verb} #{operation.path}" do
      result = public_send(operation.verb, operation.path)
      expect(result.code.to_s).to eq(operation.responses.keys[0])
      expect_json_types(message: :string)
    end
  end
end
