require 'psych'

module PathParameterizer
  PARAMETER_TOKEN_REGEXP = /\{([^\}]*)\}/im

  # Responsible for replacing parameter tokens with values defined in the appropriate parameter dictionaries.
  #
  # @param [#debug] logger
  # @param [String] application_name_under_test
  # @param [String] path
  # @param [String] context
  # @return [String] The modified path
  def self.call(logger:, application_name_under_test:, path:, context: nil)
    original_path = path
    parameters = path.scan(PARAMETER_TOKEN_REGEXP)
    if parameters.empty?
      logger.debug(context: "Path is not parameterized", path: path)
      return path
    else
      logger.debug(context: "Path is parameterized", path: path)
      finder = ParameterFinder.new(application_name_under_test: application_name_under_test)
      parameters.flatten.each do |parameter|
        value = finder.find(key: parameter, context: context)
        logger.debug(context: "Replacing {#{parameter}} with #{value.inspect}", path: original_path)
        path = path.sub("{#{parameter}}", value)
      end
      logger.debug(context: "Using #{path.inspect} for parameterized path", path: original_path)
      return path
    end
  end

  def self.call_query_parameterizer(logger:, application_name_under_test:, operation:, context: nil)
    current_operation = operation
    query_parameters = current_operation.parameters
    if query_parameters.empty?
      logger.debug(context: "URL is not query parameterized", path: current_operation.path)
      return current_operation.path
    else
      logger.debug(context: "URL is query parameterized")
      finder = ParameterFinder.new(application_name_under_test: application_name_under_test)
      query_parameters.flatten.each do |parameter|
        value = finder.find(key: parameter.name, context: context)
        if parameter.in == 'query'
          logger.debug(context: "Appending #{current_operation.path} with ?#{parameter.name}", value: value)
          current_operation.path = current_operation.path + '?' + parameter.name + '=' + value
        end
      end
      logger.debug(context: "Using #{current_operation.path.inspect} as query parameterized URI", path: current_operation.path)
      return current_operation.path
    end
  end

  # Responsible for coordinating finding of parameterized keys based on a given context
  #
  # This assumes that we have two YAML files:
  # * One shared across all applications
  # * One specific to the application under test
  class ParameterFinder
    attr_reader :dictionary, :application_name_under_test
    def initialize(application_name_under_test:)
      @application_name_under_test = application_name_under_test
      build_dictionary!
    end

    # @param [String] key - the named parameter we are looking for
    # @param [String, nil] context - the context (if any) that we want to limit our lookup to
    # @return [String] the random string to use for this key
    # @raise [KeyError] If you request a named parameter that is not defined
    # @raise [RuntimeError] If there are no entries for the given context
    def find(key:, context: nil)
      subdictionary = dictionary.fetch(key)
      if ! context.nil?
        subdictionary = subdictionary.select { |item| item.fetch("context") == context }
        if subdictionary.empty?
          raise "Unable to find match for: key: #{key}, context: #{context}, application_name_under_test: #{application_name_under_test}"
        end
      end
      subdictionary.sample.fetch('value')
    end

    private

    def path_to_parameter_files
      File.join(ENV.fetch('HOME'), 'test_data/QA/parameters')
    end

    def build_dictionary!
      shared_dictionary = Psych.load_file(File.join(path_to_parameter_files, 'shared.yml'))
      application_dictionary = Psych.load_file(File.join(path_to_parameter_files, "#{application_name_under_test}.yml"))
      @dictionary = shared_dictionary.merge(application_dictionary)
    end
  end
end
