# frozen_string_literal: true
# use rspec/autorun only when you need to absolutely run *.rb files using ruby command
# require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'yaml'
require 'capybara_error_intel/dsl'
require 'capybara-screenshot/rspec'
require 'capybara/maleficent/spindle' # Auto-inject sleep intervals into DOM interactions
require 'logging'
require 'rspec/logging_helper'
require 'swagger'
require 'open-uri'
require 'airborne'
require 'selenium-webdriver'
require 'bunyan_capybara'

# Auto-require all files in spec support
Dir.glob(File.expand_path('../spec_support/**/*.rb', __FILE__)).each { |filename| require filename }

Capybara.run_server = false

spec_path = File.expand_path('../', __FILE__)
# Keep only the screenshots generated from the last failing test suite
Capybara::Screenshot.prune_strategy = :keep_last_run
Bunyan.instantiate_all_loggers!(config: ENV, path: spec_path)

# Gives access to the capybara methods
RSpec.configure do |config|
  config.include Capybara::DSL
  config.include RSpec::LoggingHelper
  config.include Bunyan
  config.include Bunyan::CapybaraInjection

  config.capture_log_messages
  # Ensuring that things run in a random order; This is a prefered mechanism
  # as it helps identify temporal couplings
  config.order = :random
  Kernel.srand config.seed

  config.before(:suite) do |rspec_suite|
    @current_logger = Bunyan.start(example: rspec_suite, config: ENV, test_handler: self)
    Bunyan.current_logger = @current_logger
    require 'byebug'; debugger
    RunIdentifier.set
    CloudwatchEventHandler.set_aws_config
    new_save_path = ScreenshotsManager.get_screenshots_save_path
    Capybara.save_path = new_save_path
    @current_logger.stop()
    Bunyan.reset_current_logger!
  end

  config.before(:example) do |rspec_example|
    @current_logger = Bunyan.start(example: rspec_example, config: ENV, test_handler: self)
    Bunyan.current_logger = @current_logger
    InitializeExample.initialize_app_host(example: rspec_example, config: ENV)
    InitializeExample.initialize_capybara_drivers!
    # Set the window size only after capybara drivers are initialized
    ResponsiveHelpers.resize_window_default('landscape')
  end

  config.after(:example) do |rspec_example|
    ErrorReporter.conditionally_report_unsuccessful_scenario(example: rspec_example)
    VerifyNetworkTraffic.report_network_traffic(driver: Capybara.current_session.driver, test_handler: self)
    @current_logger.stop()
    Bunyan.reset_current_logger!
  end
end
