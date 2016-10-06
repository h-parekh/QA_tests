require 'rubygems'
require 'rspec/autorun'
require 'rack/test'


RSpec.configure do |config|
    config.include Rack::Test::Methods
end

def app
  @app=MyApp
end

describe 'GET all collections' do

    before { get '/v1/collections' }

    it 'is successful' do
      expect(last_response.status).to eq 200
    end
end
