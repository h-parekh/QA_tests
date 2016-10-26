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
