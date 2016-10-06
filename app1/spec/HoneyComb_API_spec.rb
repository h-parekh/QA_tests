require 'rubygems'
require 'rspec/autorun'
require 'rack/test'
require 'capybara/rspec'
require 'capybara/dsl'
require 'capybara/poltergeist'
#require 'api_helper'
#require 'spec_helper'

Capybara.run_server = false
Capybara.current_driver = :poltergeist
Capybara.javascript_driver = :poltergeist
Capybara.app_host = 'https://honeycombpprd-vm.library.nd.edu/'

RSpec.configure do |config|
    config.include Rack::Test::Methods
    config.include Capybara::DSL
    config.include ApiHelper, :type=>:api
end

def app
  Rails.application
end

feature 'Collections' do
    scenario 'Get all collections' do
        get '/v1/collections'
        expect(last_response.status).to eq 200
    end
end

#puts current_url
# describe 'GET all collections' do
#
#     before { get '/v1/collections' }
#
#     it 'is successful' do
#       expect(last_response.status).to eq 200
#     end
# end
