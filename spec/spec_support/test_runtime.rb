# frozen_string_literal: true
require 'fileutils'

module RunIdentifier
  # * Provides getter and setter methods to
  # create a unique ID for identifying the test run
  def self.set
    @run_identifier = DateTime.now.strftime("%Y-%m-%dT%H:%M:%S.%L-05:00")
    Bunyan.current_logger.debug(context: 'RunIdentifier set')
  end

  def self.get
    @run_identifier
  end
end

module ScreenshotsManager
  # * Create tmp/screenshots dir if not present
  # * Remove directories older than value specified in argument
  # * returns a relative path of the directory to which current test should save screenshots
  # @example 'tmp/screenshots/2017-04-17T12:03:57.859-05:00'
  # @return [String]
  def self.get_screenshots_save_path(runs: 5)
    screenshots_root = 'tmp/screenshots/'
    current_working_directory = Dir.pwd
    FileUtils.mkdir_p(screenshots_root)
    Dir.chdir(screenshots_root)
    screenshots_directories = Dir.glob('*').select { |f| File.directory? f } # Returns a list of all screenshots directories in screenshots_root
    screenshots_directories.reverse.each_with_index { |dir, index|
      if index >= runs
        FileUtils.rm_rf(dir)
      end
    }

    # Using value of @run_identifier as directory name
    FileUtils.mkdir RunIdentifier.get
    Dir.chdir(current_working_directory) # Return to current directory so screenshots are in the right place
    File.join(screenshots_root, RunIdentifier.get)
    Bunyan.current_logger.debug(context: 'Screenshots Save Path found')
  end
end

module InitializeExample
  # * Checks if value of ENVIRONMENT is a URL or key
  # * Sets Capybara.app_host to a valid URL
  def self.initialize_app_host(example:, config:)
    @example = example
    @config = config
    initialize_example_variables!
    if valid_url?(@example_variable.environment_under_test)
      Bunyan.current_logger.debug(context: "ENVIRONMENT variable has a valid URL")
      set_capybara_app_host(@example_variable.environment_under_test)
    else
      Bunyan.current_logger.debug(context: "Looking up '#{@example_variable.environment_under_test}' in config or secret files")
      find_app_host_url
    end
  end

  # * Checks if the corresponding config file of applcation under test holds a valid URL for given key
  # * If not, this method proceeds to lookup the secret files
  # NOTE: This method always expects the key (prep, prod..) to be present in application config file even if the value is stored in secret files
  def self.find_app_host_url
    begin
      value_from_config_file = find_url_from_config_file
      if valid_url?(value_from_config_file)
        Bunyan.current_logger.debug(context: "Value for key '#{@example_variable.environment_under_test}' in config file has a valid URL: '#{value_from_config_file}'")
        set_capybara_app_host(value_from_config_file)
      else
        Bunyan.current_logger.debug(context: "Value for key '#{@example_variable.environment_under_test}' in config file is not a valid URL: '#{value_from_config_file}'")
        Bunyan.current_logger.debug(context: "Looking up in secret parameter files")
        value_from_secret_files = find_url_from_secret_files
        if valid_url?(value_from_secret_files)
          Bunyan.current_logger.debug(context: "Value for key '#{@example_variable.environment_under_test}' in secret files has a valid URL: '#{value_from_secret_files}'")
          set_capybara_app_host(value_from_secret_files)
        else
          Bunyan.current_logger.error(context: "Value for key '#{@example_variable.environment_under_test}' in secret files is not a valid URL: '#{value_from_secret_files}'")
          Bunyan.current_logger.error(context: "Unable to set Capybara.app_host")
          Bunyan.current_logger.error(context: "Aborting scenario")
          exit!
        end
      end
    rescue KeyError => e
      Bunyan.current_logger.error(context: "Key '#{@example_variable.environment_under_test}' not found in config file", location_of_config_file: "#{@path_to_environment_config_file}")
      Bunyan.current_logger.error(context: "Provide a valid URL that starts with 'https' or use pre-configured config keys: #{@servers_by_environment}")
      exit!
    end
  end

  def self.find_url_from_config_file
    @path_to_environment_config_file = File.expand_path("./#{@example_variable.application_name_under_test}/#{@example_variable.application_name_under_test}_config.yml", @example_variable.path_to_spec_directory)
    @servers_by_environment = YAML.load_file(@path_to_environment_config_file)
    @servers_by_environment.fetch(@example_variable.environment_under_test)
  end

  def self.find_url_from_secret_files
    finder = PathParameterizer::ParameterFinder.new(application_name_under_test: @example_variable.application_name_under_test)
    finder.find(key: @example_variable.environment_under_test)
  end

  def self.set_capybara_app_host(url)
    Capybara.app_host = url.chomp("/")
    Bunyan.current_logger.debug(context: "Capybara.app_host set to #{Capybara.app_host}")
  end

  def self.initialize_example_variables!
    @example_variable = BunyanVariableExtractor.call(path: @example.metadata.fetch(:absolute_file_path), config: @config)
  end

  def self.valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

  # Enforce a driver to specific applications here
  # Example: 'dave' => :poltergeist
  CAPYBARA_DRIVER_MAP = {

  }.freeze

  DEFAULT_CAPYBARA_DRIVER = :poltergeist

  def self.initialize_capybara_drivers!
    if ENV['CHROME_HEADLESS']
      initialize_chrome_headless_driver
      @capybara_driver_name = :chrome_headless
    else
      @capybara_driver_name = CAPYBARA_DRIVER_MAP.fetch(@example_variable.application_name_under_test, :poltergeist)
    end
    Capybara.current_driver = @capybara_driver_name
    Capybara.javascript_driver = @capybara_driver_name
  end

  def self.initialize_chrome_headless_driver
    Capybara.register_driver :chrome_headless do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: {
        args: %w[ no-sandbox headless disable-gpu ]
      }
    )
    Capybara::Selenium::Driver.new(app,
                                browser: :chrome,
                                desired_capabilities: capabilities)
    end
  end

  # Checks for existence of VERSION_NUMBER in ENV config, and exits if it's not found
  # NOTE: This method is ONLY being called from application specific spec helpers for
  # those applications where asserting for version numbers of is required
  # Example: spec/usurper/usurper_spec_helper.rb
  def self.require_version_number
    if ENV['VERSION_NUMBER'].nil?
      Bunyan.current_logger.error(context: "VERSION_NUMBER not found in ENV config")
      Bunyan.current_logger.error(context: "Provide VERSION_NUMBER of application being tested")
      exit!
    end
  end

  # Checks for existence of RELEASE_NUMBER in ENV config, and exits if it's not found
  # NOTE: This method is ONLY being called from application specific spec helpers for
  # those tests where asserting for release numbers of is required
  # Example: spec/contentful/contentful_spec_helper.rb
  def self.require_release_number
    if ENV['RELEASE_NUMBER'].nil?
      Bunyan.current_logger.error(context: "RELEASE_NUMBER not found in ENV config")
      Bunyan.current_logger.error(context: "Provide RELEASE_NUMBER of application being tested, ex: r20170922")
      exit!
    end
  end

  # Checks for existence of USE_CONTENTFUL_SPACE in ENV config, checks if the proper values are assigned to it, and exits if it's not found or if incorrect values are assigned
  # NOTE: This method is ONLY being called from application specific spec helpers for
  # those tests where assertion of contentful space of is required
  # Example: spec/contentful/contentful_spec_helper.rb
  def self.require_contentful_space
    if ENV['USE_CONTENTFUL_SPACE'].nil?
      Bunyan.current_logger.error(context: "USE_CONTENTFUL_SPACE not found in ENV config")
      Bunyan.current_logger.error(context: "Provide USE_CONTENTFUL_SPACE to designate desired Contentful space (prod or prep)")
      exit!
    elsif ENV['USE_CONTENTFUL_SPACE'] != 'prod' && ENV['USE_CONTENTFUL_SPACE'] != 'prep'
      Bunyan.current_logger.error(context: "Only options for USE_CONTENTFUL_SPACE are prod or prep")
      exit!
    end
  end
end

module ErrorReporter
  def self.conditionally_report_unsuccessful_scenario(example:)
    @example = example
    return true if successful_scenario?
    # Leverage RSpec's logic to zero in on the location of failure from the exception backtrace
    location_of_failure = RSpec.configuration.backtrace_formatter.format_backtrace(example.exception.backtrace).first
    Bunyan.current_logger.error(context: "FAILED example", location_of_failure: location_of_failure, message: @example.exception.message)
  end

  def self.successful_scenario?
    @example.exception.nil?
  end
end

module VerifyNetworkTraffic
  # leverages network_traffic method of poltergeist driver to verify
  # that all the network calls for static assets and 3rd party support
  # are working on the site
  def self.exclude_uri_from_network_traffic_validation
    @exclude_uri_from_network_traffic_validation ||= []
  end

  def self.report_network_traffic(driver:, test_handler:)
    @driver = driver
    @test_handler = test_handler
    return true unless driver_allows_network_traffic_verification?
    return true if ENV.fetch('SKIP_VERIFY_NETWORK_TRAFFIC', false)
    return true unless test_needs_network_verification?
    Bunyan.current_logger.info(context: "verifying_all_network_traffic") do
      verify_network_traffic(driver: driver)
    end
  end

  def self.test_needs_network_verification?
    input = ARGV.join.split('/')
    #splits the test path into individual array elements
    !input.include?('integration')
  end

  def self.driver_allows_network_traffic_verification?
    Capybara.current_driver == :poltergeist
  end

  # This method slices all the network traffic into 4 categories and validates them:
  # non_uri_resources: resources that are not URIs (come through due to bugs in Poltergeist)
  # not_verified_resources: resources that have been requested not to be verified (Assets that may be failing)
  # failed_resources: resources that should give an error message on certain conditions
  def self.verify_network_traffic(driver:)
    failed_resources = []
    not_verified_resources = []
    non_uri_resources = []
    verification_passed_resources = []
    driver.network_traffic.each do |request|
      request.response_parts.uniq(&:url).each do |response|
      if ! InitializeExample.valid_url?(response.url)
          resource_hash = { url: response.url, status_code: response.status }
          non_uri_resources << resource_hash
          Bunyan.current_logger.debug(context: "Verification skipped, Resource isn't of type URI", url: response.url, status_code: response.status)
        elsif !@exclude_uri_from_network_traffic_validation.nil? && (@exclude_uri_from_network_traffic_validation.include? URI.parse(response.url).request_uri)
          resource_hash = { url: response.url, status_code: response.status }
          not_verified_resources << resource_hash
          Bunyan.current_logger.debug(context: "Verification skipped, resource exists in @exclude_uri_from_network_traffic_validation", url: response.url, status_code: response.status)
        elsif (400..599).cover? response.status
          resource_hash = { url: response.url, status_code: response.status }
          failed_resources << resource_hash
          Bunyan.current_logger.error(context: "Verification failed, response code in range 400..599", url: response.url, status_code: response.status)
        elsif ! ENV['ALLOW_ALL_NETWORK_HOSTS'] && response.url =~ Bunyan::DISALLOWED_NETWORK_TRAFFIC_REGEXP
          resource_hash = { url: response.url, status_code: response.status }
          failed_resources << resource_hash
          Bunyan.current_logger.error(context: "Verification failed, url is blocked by Bunyan::DISALLOWED_NETWORK_TRAFFIC_REGEXP", url: response.url, status_code: response.status, disallowed_network: "true")
        else
          resource_hash = { url: response.url, status_code: response.status }
          verification_passed_resources << resource_hash
          Bunyan.current_logger.debug(context: "Verification passed", url: response.url, status_code: response.status)
        end
      end
    end
    @test_handler.expect(failed_resources).to @test_handler.be_empty, build_failed_messages_for(failed_resources)
  end


  def self.build_failed_messages_for(failed_resources)
    text = "Resource Error:"
    failed_resources.each do |obj|
      text += "\n\tStatus: #{obj.fetch(:status_code)}\tURL: #{obj.fetch(:url)}"
    end
    text
  end
end
