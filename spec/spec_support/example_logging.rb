# frozen_string_literal: true

# This module provides mechanisms for consolidating logging
#
# It is intended to be included in the RSpec example context so as to expose
# the @current_logger instance variable
module ExampleLogging
  DEFAULT_ENVIRONMENT = 'prod'
  DEFAULT_LOG_LEVEL = 'info'
  AVAILABLE_LOG_LEVELS = %w(debug info warn error fatal).freeze

  # Given that we want to send logs to different locations based on application,
  # we need to initialize different loggers. We also don't want to keep adding
  # appenders, so this is a means of instantiating all of those loggers before
  # we run any of the examples.
  #
  # @note Call this method no more than once per spec
  def self.instantiate_all_loggers!(config: ENV)
    raise "You already called instantiate_all_loggers!" if @called
    @called = true
    layout = Logging.layouts.pattern(format_as: :json, date_pattern: "%Y-%m-%d %H:%M:%S.%L")
    Logging.appenders.stdout(layout: layout)
    entries = Dir.glob(File.expand_path('../../*', __FILE__))
    entries.each do |entry|
      application_name_under_test = entry.split('/').last
      logger = Logging.logger[application_name_under_test]
      log_filename = File.expand_path("../../logs/#{application_name_under_test}.log", __FILE__)
      logger.add_appenders('stdout', Logging.appenders.file(log_filename, layout: layout))
      logger.level = config.fetch('LOG_LEVEL', DEFAULT_LOG_LEVEL).to_sym
    end
  end

  def self.start(**kwargs)
    ExampleWrapperWithLogging.new(**kwargs).start
  end

  def current_logger
    @current_logger
  end

  # This module injects logging behavior whenever Capybara does the following:
  #  * clicks
  #  * visits
  #  * submits
  module CapybaraInjection
    def click(*args, &block)
      super.tap { log_url_action(context: __method__) }
    end

    def submit(*args, &block)
      super.tap { log_url_action(context: __method__) }
    end

    def visit(*arg, &block)
      super.tap { log_url_action(context: __method__) }
    end

    private

      def log_url_action(context:)
        @current_logger.info(context: context, path: current_path, host: Capybara.app_host)
      end
  end

  # Responsible for wrapping the testing process within a predicatable logging environment.
  # The wrapper behaves like the underlying logger.
  class ExampleWrapperWithLogging
    # This repository tests multiple applications. Each named application is a subdirectory of './spec/'
    # @example 'curate'
    # @return [String]
    attr_reader :application_name_under_test

    # Used to configure the specifics of this application
    # @example ENV
    # @return [Hash]
    attr_reader :config

    # The current logger for the given scenario
    # @return [ExampleLogging::CurrentLogger]
    attr_reader :current_logger

    # The Environment in which we are running our tests against
    # @example 'prod'
    # @return [String]
    attr_reader :environment_under_test

    # The Rspec example that will be run
    # @return [RSpec::Core::Example]
    attr_reader :example

    # Where can we find the global spec_helper.rb file?
    # @return [String]
    attr_reader :path_to_spec_directory

    # The context in which the tests are actually run. From here we can make assertions/expections.
    # @return [#expect]
    attr_reader :test_handler

    # The type of test (e.g. integration or functional) that is being run.
    # @example 'integration'
    # @return [String]
    attr_reader :test_type

    def initialize(example:, test_handler:, config: ENV)
      @example = example
      @config = config
      @test_handler = test_handler
      @environment_under_test = config.fetch('ENVIRONMENT', DEFAULT_ENVIRONMENT)
      @path_to_spec_directory = File.expand_path('../../', __FILE__)
      initialize_example_variables!
      initialize_app_host!
      @current_logger = Logging.logger[application_name_under_test]
    end

    # Responsible for logging the start of a test
    # @return [ExampleLogging::ExampleWrapper]
    def start
      info(context: "BEGIN example", example: example.full_description, location: example.location)
      self
    end

    # Responsible for consistent logging of the end steps of a test
    # @param driver [#network_traffic]
    # @return [ExampleLogging::ExampleWrapper]
    def stop(driver:)
      conditionally_report_unsuccessful_scenario
      report_network_traffic(driver: driver)
      report_end_of_example
      self
    end

    private

      def conditionally_report_unsuccessful_scenario
        return true if successful_scenario?
        # Leverage RSpec's logic to zero in on the location of failure from the exception backtrace
        location_of_failure = RSpec.configuration.backtrace_formatter.format_backtrace(example.exception.backtrace).first
        error(context: "FAILED example", location_of_failure: location_of_failure, message: example.exception.message)
      end

      def successful_scenario?
        example.exception.nil?
      end

      def report_network_traffic(driver:)
        info(context: "verifying_all_network_traffic") do
          verify_network_traffic(driver: driver)
        end
      end

      def report_end_of_example
        info(context: "END example", example: example.full_description, location: example.location)
      end

    public

    # Log a "debug" level event
    # @param context [#to_s] The context of what is being logged
    # @param kwargs [Hash] The other key/value pair information to log
    # @yield If a block is given, it will log the begining, then yield, then log the ending
    def debug(context:, **kwargs, &block)
      log(severity: __method__, context: context, **kwargs, &block)
    end

    # Log an "info" level event
    # @param context [#to_s] The context of what is being logged
    # @param kwargs [Hash] The other key/value pair information to log
    # @yield If a block is given, it will log the begining, then yield, then log the ending
    def info(context:, **kwargs, &block)
      log(severity: __method__, context: context, **kwargs, &block)
    end

    # Log a "warn" level event
    # @param context [#to_s] The context of what is being logged
    # @param kwargs [Hash] The other key/value pair information to log
    # @yield If a block is given, it will log the begining, then yield, then log the ending
    def warn(context:, **kwargs, &block)
      log(severity: __method__, context: context, **kwargs, &block)
    end

    # Log a "error" level event
    # @param context [#to_s] The context of what is being logged
    # @param kwargs [Hash] The other key/value pair information to log
    # @yield If a block is given, it will log the begining, then yield, then log the ending
    def error(context:, **kwargs, &block)
      log(severity: __method__, context: context, **kwargs, &block)
    end

    # Log a "fatal" level event
    # @param context [#to_s] The context of what is being logged
    # @param kwargs [Hash] The other key/value pair information to log
    # @yield If a block is given, it will log the begining, then yield, then log the ending
    def fatal(context:, **kwargs, &block)
      log(severity: __method__, context: context, **kwargs, &block)
    end

    private

      def log(severity:, context:, **kwargs)
        message = ""
        kwargs.each { |key, value| message += %(#{key}: #{value.inspect}\t) }
        message = message.strip
        if block_given?
          @current_logger.public_send(severity, %(test_type: #{test_type}\t context: "BEGIN #{context}\t#{message}))
          yield
          @current_logger.public_send(severity, %(test_type: #{test_type}\t context: "END #{context}\t#{message}))
        else
          @current_logger.public_send(severity, %(test_type: #{test_type}\t context: "#{context}"\t#{message}))
        end
      end

      def verify_network_traffic(driver:)
        failed_resources = []
        driver.network_traffic.each do |request|
          request.response_parts.uniq(&:url).each do |response|
            if (400..599).cover? response.status
              resource_hash = { url: response.url, status_code: response.status }
              failed_resources << resource_hash
              error(context: "verifying_network_traffic", url: response.url, status_code: response.status)
            else
              debug(context: "verifying_network_traffic", url: response.url, status_code: response.status)
            end
          end
          test_handler.expect(failed_resources).to test_handler.be_empty, build_failed_messages_for(failed_resources)
        end
      end

      def build_failed_messages_for(failed_resources)
        text = "Resource Error:"
        failed_resources.each do |obj|
          text += "\n\tStatus: #{obj.fetch(:status)}\tURL: #{obj.fetch(:url)}"
        end
        text
      end

      def initialize_example_variables!
        spec_path = @example.metadata.fetch(:absolute_file_path)
        spec_sub_directory = spec_path.sub("#{path_to_spec_directory}/", '').split('/')
        @application_name_under_test = spec_sub_directory[0]
        @test_type = spec_sub_directory[1]
      end

      def initialize_app_host!
        servers_by_environment = YAML.load_file(
          File.expand_path("./#{application_name_under_test}/#{application_name_under_test}_config.yml", path_to_spec_directory)
        )
        Capybara.app_host = servers_by_environment.fetch(environment_under_test)
      end
  end
  private_constant :ExampleWrapperWithLogging
end
