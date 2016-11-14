require 'rubygems'
#use rspec/autorun only when you need to absolutely run *.rb files using ruby command
#require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/dsl'
require 'capybara/poltergeist'
#HighLine provides a robust system for requesting data from a user
require 'highline/import'
require 'yaml'

Capybara.run_server = false
Capybara.current_driver = :poltergeist
#Capybara.default_max_wait_time = 10 #This sets wait time globally

#If you don't provide this, Capybara will pick  the selenium driver for javascript_driver by default
Capybara.javascript_driver = :poltergeist

#Gives access to the capybara methods
RSpec.configure do |config|
  config.include Capybara::DSL

  # Ensuring that things run in a random order; This is a prefered mechanism
  # as it helps identify temporal couplings
  config.order = :random
  Kernel.srand config.seed

  config.before(:example) do |ex|
    set_application_host_by_example(ex)
  end
end

def set_application_host_by_example(example)
  spec_helper_path = File.dirname(__FILE__)
  spec_path = example.metadata.fetch(:absolute_file_path)
  spec_sub_directory = spec_path.sub("#{spec_helper_path}/", '').split('/').first
  # TODO: There may be a mix of environments that we want to test; How to handle this? The current assumption is test the same environment.
  environment = ENV.fetch('ENVIRONMENT', 'prod')
  servers_by_environment = YAML::load_file(File.expand_path("./#{spec_sub_directory}/#{spec_sub_directory}_config.yml", spec_helper_path))
  Capybara.app_host = servers_by_environment.fetch(environment)
end
