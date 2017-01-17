require 'testApi/testApi_spec_helper'
require 'airborne'
require 'swagger'

api = Swagger.load('/Users/hparekh/git/test_api/definitions/swagger.yaml')
Airborne.configure do |config|
  config.base_url = 'http://testcontroller02.library.nd.edu:5602' + api.basePath
end

describe 'Validate response' do
  it 'should validate types' do
  api.operations.each do | operation |
    # controller_name = operation.path
    # controller_action = operation.verb
    puts operation.signature
    # expect_json_types(message: :string)
    # expect_status('200 OK')
  end
  end
end
