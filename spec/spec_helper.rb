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
require 'spec_support/verify_network'
require 'spec_support/inject_current_url_logging'

Capybara.run_server = false

class PoltergeistLog
  def initialize
    @log = Logging.logger['poltergeist']
    Logging.appenders.stdout(layout: Logging.layouts.pattern(format_as: :json))
    @log.add_appenders('stdout')
    @log.level = :fatal
  end

  def puts(*args)
    @log.info(*args)
  end
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, debug: true, logger: PoltergeistLog.new)
end
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

  config.before(:example) do |ex|
    application_host_by_example(ex)
  end

  config.after(:example) do |_ex|
    VerifyNetwork.verify_network_traffic(page, self)
  end
end

def application_host_by_example(example)
  spec_helper_path = File.dirname(__FILE__)
  spec_path = example.metadata.fetch(:absolute_file_path)
  spec_sub_directory = spec_path.sub("#{spec_helper_path}/", '').split('/').first
  # TODO: There may be a mix of environments that we want to test; How to handle this? The current assumption is test the same environment.
  environment = ENV.fetch('ENVIRONMENT', 'prod')
  servers_by_environment = YAML.load_file(File.expand_path("./#{spec_sub_directory}/#{spec_sub_directory}_config.yml", spec_helper_path))
  Capybara.app_host = servers_by_environment.fetch(environment)
end
