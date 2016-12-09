# frozen_string_literal: true
require 'rubygems'
# use rspec/autorun only when you need to absolutely run *.rb files using ruby command
# require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/dsl'
require 'capybara/poltergeist'
# HighLine provides a robust system for requesting data from a user
require 'highline/import'
require 'yaml'
require 'capybara_error_intel/dsl'
require 'capybara-screenshot/rspec'
require 'logging'
require 'rspec/logging_helper'
require 'spec_support/current_example'
require 'spec_support/verify_network'
require 'spec_support/inject_current_url_logging'

Capybara.run_server = false

Capybara.current_driver = :poltergeist
# Capybara.default_max_wait_time = 10 #This sets wait time globally

# If you don't provide this, Capybara will pick  the selenium driver for javascript_driver by default
Capybara.javascript_driver = :poltergeist

# set the save path used in capybara-screenshot
Capybara.save_path = './tmp/screenshots'
# Keep only the screenshots generated from the last failing test suite
Capybara::Screenshot.prune_strategy = :keep_last_run

# Gives access to the capybara methods
RSpec.configure do |config|
  config.include Capybara::DSL
  config.include RSpec::LoggingHelper
  config.include InjectCurrentUrlLogging
  config.capture_log_messages
  # Ensuring that things run in a random order; This is a prefered mechanism
  # as it helps identify temporal couplings
  config.order = :random
  Kernel.srand config.seed

  config.around(:example) do |example|
    @current_example = CurrentExample.new(example: example, config: ENV)
    @current_example.run { example.run }
  end
end
