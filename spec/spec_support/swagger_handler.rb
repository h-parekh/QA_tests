# frozen_string_literal: true
# This class provides a mechanism to load swagger definition given a project repository
# It leverages methods exposed by the gem 'swagger-parser'
#   https://github.com/alexpjohnson/swagger-parser
class SwaggerHandler
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

  def operations
    @operations ||= swagger.operations.map { |operation| SwaggerOperationDecorator.new(swagger, operation) }
  end

  private

    def set_project_config!
      repo_config_file = YAML.load_file(File.expand_path("../../#{example_variable.application_name_under_test}/#{example_variable.application_name_under_test}_repo_config.yml", __FILE__))
      @project_user_name = repo_config_file.fetch('repo_url').split('/')[3]
      @project_repository_name = repo_config_file.fetch('repo_url').split('/')[4]
    end

    def swagger
      @swagger ||= begin
        url_to_swagger_def = File.join('https://raw.githubusercontent.com/', @project_user_name, @project_repository_name, 'master', 'definitions', 'swagger.yml')
        swagger_yaml = open(url_to_swagger_def, "Authorization" => "token #{@access_token_value}").read
        Swagger.build(swagger_yaml, format: :yaml)
      rescue ArgumentError
        unreadable_swagger_file = YAML.load(swagger_yaml)
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
        hash_to_search.find{ |*a| subset_of_hash_to_search=check_for_nested_swagger_def(a.last) }
        subset_of_hash_to_search
      end
    end

    # This is a temporary implementation until I conosildate all configs using Figaro
    def set_access_token_value!
      user_home_dir = File.expand_path('~')
      git_access_config_file = YAML.load_file(File.join(user_home_dir.to_s, 'test_data/QA/git_access.yaml'))
      @access_token_value = git_access_config_file.fetch("access_token")
    end

    attr_reader :example_variable, :config

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
