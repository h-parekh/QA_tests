# frozen_string_literal: true
require 'fileutils'

module RunIdentifier
  # * Provides getter and setter methods to
  # create a unique ID for identifying the test run
  def self.set
    @run_identifier = DateTime.now.strftime("%Y-%m-%dT%H:%M:%S.%L-05:00")
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
  end
end

module InitializeExample
  # * Checks if value of ENVIRONMENT is a URL or key
  # * Sets Capybara.app_host to a URL
  def self.initialize_app_host(example:, config:)
    @example = example
    @config = config
    initialize_example_variables!
    if valid_url?(@example_variable.environment_under_test)
      Capybara.app_host = @example_variable.environment_under_test
    else
      servers_by_environment = YAML.load_file(
        File.expand_path("./#{@example_variable.application_name_under_test}/#{@example_variable.application_name_under_test}_config.yml", @example_variable.path_to_spec_directory)
      )
      Capybara.app_host = servers_by_environment.fetch(@example_variable.environment_under_test)
    end
  end

  def self.initialize_example_variables!
    @example_variable = ExampleVariableExtractor.call(path: @example.metadata.fetch(:absolute_file_path), config: @config)
  end

  def self.valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end
end
