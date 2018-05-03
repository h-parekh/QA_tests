# frozen_string_literal: true

# This module will provide spec filtering capabilities to the framework
# based on whether value of ENVIRONMENT variable
module SpecFilterManager
  # * when running against production:
  #     * only runs specs with rspec tag 'read_only'
  #     * EXCLUDE specs with rspec tag 'nonprod_only'
  # * If a scenario has both these tags, then Rspec prioritizes exclusion
  # @example The following scenario will not run
  # scenario 'Loads Home Page',:read_only, :nonprod_only do
  #   visit '/'
  # end
  def self.set_default_filters(config:)
    @example_variable = BunyanVariableExtractor.call(path: config.files_to_run[0], config: ENV)
    if environment_under_test_is_prod?
      puts "'ENVIRONMENT' categorized as 'production', running only filtered specs"
      RSpec.configure do |c|
        c.filter_run_including :read_only
        c.filter_run_excluding :nonprod_only
      end
    elsif environment_under_test_is_nonprod?
      puts "'ENVIRONMENT' categorized as 'non-production', no filters, running all specs"
    else
      # I don't want to assume anything based on regex patterns when 'ENVIRONMENT' is a URL
      # Especially in cases such as that of library website when the URLs are cloudfront URLs
      # I'm enforcing an additional input from user to determine if its a production or non_production endpoint
      puts "Can't categorize 'ENVIRONMENT' as either 'production' or 'non-production', excluding all specs"
      puts "If you're providing a url as value for 'ENVIRONMENT',"
      puts "Please retry with an additional input variable 'ENVIRONMENT_CATEGORY'"
      puts "Value of 'ENVIRONMENT_CATEGORY' should be one of these:"
      puts "['local', 'dev', 'test', 'prep', 'pprd', 'staging', 'staging6', 'staging8','staging9', 'prod']"
      # Using a random string as argument to filter_run_including method will skip all tests
      RSpec.configure do |c|
        c.filter_run_including(generate_random_string.to_sym)
      end
    end
  end

  def self.environment_under_test_is_prod?
    possible_production_keys = ['prod']
    (possible_production_keys.include? @example_variable.environment_under_test) ||
      (possible_production_keys.include? ENV['ENVIRONMENT_CATEGORY'])
  end

  def self.environment_under_test_is_nonprod?
    possible_non_production_keys = ['local', 'dev', 'test', 'prep', 'pprd', 'staging', 'staging6', 'staging8', 'staging9']
    (possible_non_production_keys.include? @example_variable.environment_under_test) ||
      (possible_non_production_keys.include? ENV['ENVIRONMENT_CATEGORY'])
  end

  def self.generate_random_string
    (0...100).map { (65 + rand(26)).chr }.join
  end
end
