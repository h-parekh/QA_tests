# frozen_string_literal: true
# use rspec/autorun only when you need to absolutely run *.rb files using ruby command
# require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'yaml'
require 'capybara_error_intel/dsl'
require 'capybara-screenshot/rspec'
require 'logging'
require 'rspec/logging_helper'
require 'swagger'
require 'open-uri'
require 'airborne'

# Auto-require all files in spec support
Dir.glob(File.expand_path('../spec_support/**/*.rb', __FILE__)).each { |filename| require filename }

Capybara.run_server = false

# Keep only the screenshots generated from the last failing test suite
Capybara::Screenshot.prune_strategy = :keep_last_run
ExampleLogging.instantiate_all_loggers!(config: ENV)

# Gives access to the capybara methods
RSpec.configure do |config|
  config.include Capybara::DSL
  config.include RSpec::LoggingHelper
  config.include ExampleLogging
  config.include ExampleLogging::CapybaraInjection

  config.capture_log_messages
  # Ensuring that things run in a random order; This is a prefered mechanism
  # as it helps identify temporal couplings
  config.order = :random
  Kernel.srand config.seed

  config.before(:suite) do
    RunIdentifier.set
    CloudwatchEventHandler.set_aws_config
    new_save_path = ScreenshotsManager.get_screenshots_save_path
    Capybara.save_path = new_save_path
  end

  config.before(:example) do |rspec_example|
    @current_logger = ExampleLogging.start(example: rspec_example, config: ENV, test_handler: self)
    ExampleLogging.current_logger = @current_logger
    InitializeExample.initialize_app_host(example: rspec_example, config: ENV)
  end

  config.after(:example) do |_|
    @current_logger.stop(driver: Capybara.current_session.driver)
    ExampleLogging.reset_current_logger!
  end
end
