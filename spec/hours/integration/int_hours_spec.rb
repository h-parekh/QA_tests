#frozen_string_literal: true
require 'hours/hours_spec_helper'

describe 'Hours API test' do
  SwaggerHandler.operations(for_file_path: __FILE__).each do |operation|
    it "calls #{operation.verb} #{operation.path}" do
      result = public_send(operation.verb, operation.url)
      expect(result.code.to_s).to eq(operation.responses.keys[0])
      #expect_json_types(redirect: :string)
    end
  end
end
