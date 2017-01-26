# frozen_string_literal: true
require 'testApi/testApi_spec_helper'

describe 'API tests using swagger definition' do
  ApiConfig.swagger_object.operations.each do |operation|
    it "calls #{operation.verb} #{operation.path}" do
      result = RestClient::Response.new
      case operation.verb
      when :get
        result = get operation.path
      when :post
        result = post operation.path
      end
      expect(result.code.to_s).to eq(operation.responses.keys[0])
      expect_json_types(message: :string)
    end
  end
end
