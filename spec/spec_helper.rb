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

#Enable this to work with hidden fields
#Capybara.ignore_hidden_elements = false
app_name = 'rbsc'
config_file = app_name + '_config.yml'
trigger_file = app_name + '_trigger.yml'

cnf = YAML::load_file(File.expand_path("../" + app_name + "/" + config_file, __dir__))
trigger = YAML::load_file(File.expand_path("../" + app_name + "/" + trigger_file, __dir__))
target_env = trigger['target']

if target_env.nil? || target_env.to_s == ''
  target_env = ask("Enter target env, options are pprd or prod:  ") { |q| q.echo = true }
end

Capybara.app_host = cnf.fetch(target_env)

#Gives access to the capybara methods
RSpec.configure do |config|
    config.include Capybara::DSL
end
