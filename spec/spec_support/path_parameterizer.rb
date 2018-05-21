# frozen_string_literal: true

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
    else
      logger.debug(context: "Path is parameterized", path: path)
      finder = ParameterFinder.new(application_name_under_test: application_name_under_test)
      parameters.flatten.each do |parameter|
        value = finder.find(key: parameter, context: context)
        logger.debug(context: "Replacing {#{parameter}} with #{value.inspect}", path: original_path)
        path = path.sub("{#{parameter}}", value)
      end
      logger.debug(context: "Using #{path.inspect} for parameterized path", path: original_path)
    end
    path
  end

  # Substite any parameterized variables in the given `operation#path` to actual parameters.
  #
  # @param [#debug] logger: responds to debug
  # @param [String] application_name_under_test
  # @param [SwaggerHandler::SwaggerOperationDecorator] operation: A SwaggerOperation object (e.g. #path, #parameters)
  # @param [String, NilClass] context: for parameter substitution, what context should we narrow our search for the parameter
  # @return [String] The transformed path based
  def self.call_query_parameterizer(logger:, application_name_under_test:, operation:, context: nil)
    current_operation = operation
    parameters = current_operation.parameters
    if parameters.empty?
      logger.debug(context: "URL is not query parameterized", path: current_operation.path)
    else
      logger.debug(context: "URL is query parameterized")
      finder = ParameterFinder.new(application_name_under_test: application_name_under_test)
      query_parameters = []
      parameters.flatten.each do |parameter|
        value = finder.find(key: parameter.name, context: context)
        # Are we processing a GET requests query parameter; If so the substitution is different.
        if parameter.in == 'query'
          logger.debug(context: "Appending #{current_operation.path} with query parameter #{parameter.name}", value: value)
          query_parameters.push "#{parameter.name}=#{value}"
        end
      end

      if query_parameters.any?
        current_operation.path = current_operation.path + '?' + query_parameters.join("&")
      end

      logger.debug(context: "Using #{current_operation.path.inspect} as query parameterized URI", path: current_operation.path)
    end
    current_operation.path
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
    # @raise [TypeError] If the subdictionary is a type other than Hash or Array
    def find(key:, context: nil)
      subdictionary = dictionary.fetch(key)
      unless context.nil?
        subdictionary = subdictionary.select { |item| item.fetch("context") == context }
        if subdictionary.empty?
          raise "Unable to find match for: key: #{key}, context: #{context}, application_name_under_test: #{application_name_under_test}"
        end
      end
      if subdictionary.instance_of?(Hash) # The key has only one value, ex: prep/prod URL endpoints
        subdictionary.fetch('value')
      elsif subdictionary.instance_of?(Array) # The key has multiple values possible and we want to pick one of them, ex: systemId
        subdictionary.sample.fetch('value')
      else
        raise "Unable to return value from subdictionary, because its neither an Array or Hash"
      end
    end

    private

      def build_dictionary!
        shared_dictionary_from_aws = Psych.load(AwsSsmHandler.get_param_from_parameter_store('/all/qa/shared'))
        application_dictionary_from_aws = Psych.load(AwsSsmHandler.get_param_from_parameter_store("/all/qa/#{application_name_under_test}"))
        @dictionary = shared_dictionary_from_aws.merge(application_dictionary_from_aws)
      end
  end
end
