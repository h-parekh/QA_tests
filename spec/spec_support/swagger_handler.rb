# frozen_string_literal: true

# This class provides a mechanism to load swagger definition given a project repository
# It leverages methods exposed by the gem 'swagger-parser'
#   https://github.com/alexpjohnson/swagger-parser
class SwaggerHandler
  # This is the first method that gets called from the spec
  # * Pulls variables frmo BunyanVariableExtractor
  # * Calls `initialize` for SwaggerHandler class
  # * Calls the `operations` instance method of SwaggerHandler class
  def self.operations(for_file_path:, config: ENV)
    @registry ||= {}
    example_variable = BunyanVariableExtractor.call(path: for_file_path, config: config)
    @registry[example_variable] ||= new(example_variable: example_variable, config: config)
    @registry[example_variable].operations
  end

  def initialize(example_variable:, config:)
    @example_variable = example_variable
    @config = config
    set_project_config!
    set_access_token_value!
  end

  # Calls `reject_operations_with_skip_tag` method and assigns the array to @filtered_operations
  # Note that it isn't changing the original 'swagger' object
  # Sets @operations variable with an array of objects of type SwaggerHandler::SwaggerOperationDecorator
  def operations
    @fitered_operations = reject_operations_with_skip_tag
    @operations ||= if ENV['SWAGGER_LOCATION'] == 'gateway'
                      @fitered_operations.map { |operation| SwaggerOperationDecorator.new(swagger_from_gateway, operation) }
                    else
                      @fitered_operations.map { |operation| SwaggerOperationDecorator.new(swagger_from_definitions, operation) }
                    end
  end

  # Returns an array of objects of type Swagger::V2::Operation
  def reject_operations_with_skip_tag
    if ENV['SWAGGER_LOCATION'] == 'gateway'
      swagger_from_gateway.operations.delete_if { |operation| !operation.tags.nil? && operation.tags.include?("skipTests") }
    else
      swagger_from_definitions.operations.delete_if { |operation| !operation.tags.nil? && operation.tags.include?("skipTests") }
    end
  end

  def self.require_swagger_location
    return unless SwaggerHandler.ensure_integration_test
    if ENV['SWAGGER_LOCATION'].nil?
      Bunyan.current_logger.error(context: "SWAGGER_LOCATION not found in ENV config")
      Bunyan.current_logger.error(context: "Provide SWAGGER_LOCATION of API being tested, ex: gateway")
      exit!
    elsif ENV['SWAGGER_LOCATION'] != "gateway" && ENV['SWAGGER_LOCATION'] != "definitions"
      Bunyan.current_logger.error(context: "SWAGGER_LOCATION is invalid.  Valid options are: definitions or gateway.")
      exit!
    end
  end

  def self.ensure_integration_test
    ARGV[0].split('/').include?('integration')
  end

  private

    def set_project_config!
      repo_config_file = YAML.load_file(File.expand_path("../../#{example_variable.application_name_under_test}/#{example_variable.application_name_under_test}_repo_config.yml", __FILE__))
      @project_user_name = repo_config_file.fetch('repo_url').split('/')[3]
      @project_repository_name = repo_config_file.fetch('repo_url').split('/')[4]
    end

    def swagger_from_gateway
      @swagger ||= begin
        url_to_swagger_def = File.join('https://raw.githubusercontent.com/', @project_user_name, @project_repository_name, 'master', 'deploy', 'gateway.yml')
        swagger_yaml = open(url_to_swagger_def, "Authorization" => "token #{@access_token_value}").read
        unreadable_swagger_file = YAML.safe_load(swagger_yaml)
        readable_swagger_json = check_for_nested_swagger_def(unreadable_swagger_file)
        Swagger.build(readable_swagger_json, format: :json)
      end
    end

    def swagger_from_definitions
      @swagger ||= begin
        url_to_swagger_def = File.join('https://raw.githubusercontent.com/', @project_user_name, @project_repository_name, 'master', 'definitions', 'swagger.yml')
        swagger_yaml = open(url_to_swagger_def, "Authorization" => "token #{@access_token_value}").read
        Swagger.build(swagger_yaml, format: :yaml)
      rescue ArgumentError
        unreadable_swagger_file = YAML.safe_load(swagger_yaml)
        swagger_yaml = check_for_nested_swagger_def(unreadable_swagger_file)
        Swagger.build(swagger_yaml, format: :json)
      end
    end

    def check_for_nested_swagger_def(unreadable_swagger_file)
      hash_to_search = unreadable_swagger_file
      key = 'swagger'
      if hash_to_search.respond_to?(:key?) && hash_to_search.key?(key)
        hash_to_search.to_json
      elsif hash_to_search.respond_to?(:each)
        subset_of_hash_to_search = nil
        hash_to_search.find { |*a| subset_of_hash_to_search = check_for_nested_swagger_def(a.last) }
        subset_of_hash_to_search
      end
    end

    # This is a temporary implementation until I conosildate all configs using Figaro
    def set_access_token_value!
      git_access_config_in_json = Psych.load(AwsSsmHandler.get_param_from_parameter_store("/all/qa/git_access_token"))
      @access_token_value = git_access_config_in_json.fetch("access_token")
    end

    attr_reader :example_variable, :config

    # As the name suggests, this class wraps objcets of type Swagger::V2::Operation and provides
    # methods to easilty read and write its variables
    # It does not change the operation itself
    class SwaggerOperationDecorator
      def initialize(swagger, operation)
        @swagger = swagger
        @operation = operation
      end

      def url
        File.join(Capybara.app_host, path)
      end

      def path
        return @path if @path
        return @operation.path if @swagger.basePath.nil?
        File.join(@swagger.basePath, @operation.path)
      end

      attr_writer :path

      def verb
        @operation.verb
      end

      def responses
        @operation.responses
      end

      def parameters
        return [] if @operation.parameters.nil?
        @operation.parameters
      end
    end
end
