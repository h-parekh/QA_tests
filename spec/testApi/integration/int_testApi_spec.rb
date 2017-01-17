require 'testApi/testApi_spec_helper'

api = Swagger.load('/Users/hparekh/git/test_api/definitions/swagger.yaml')

describe 'Validate response' do
  it 'should validate types' do
    get 'http://testcontroller02.library.nd.edu:5602/api/v1/inventory'
    puts response
    expect_json_types(message: :string)
    expect_status('200 OK')
  end
end
