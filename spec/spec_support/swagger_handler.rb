# frozen_string_literal: true
# This class provides a mechanism to load swagger definition given a project repository
# It leverages methods exposed by the gem 'swagger-rb'
# https://github.com/swagger-rb/swagger-rb
  class SwaggerHandler
    def self.operations(for_file_path:, config: ENV)
      @registry ||= {}
      example_variable = ExampleVariableExtractor.call(path: for_file_path)
      @registry[example_variable] ||= new(example_variable: example_variable, config: config)
      @registry[example_variable].operations
    end

    def initialize(example_variable:, config:)
      @example_variable = example_variable
      @config = config
    end

    def operations(&block)
      @swagger || download_and_load_definition!
      @operations ||= @swagger.operations.map { |operation| SwaggerOperationDecorator.new(@swagger, operation) }
    end

    private

    def project_user_name
      'ndlib'
    end

    def project_repository_name
      'test_api'
    end

    def download_and_load_definition!
      url_to_swagger_def = File.join('https://raw.githubusercontent.com/', project_user_name, project_repository_name, 'master', 'definitions', 'swagger.yml')
      read_git_access_token
      swagger_yaml = open(url_to_swagger_def, "Authorization" => "token #{@access_token_value}").read
      @swagger = Swagger.build(swagger_yaml, format: :yaml)
    end

# This is a temporary implementation until I conosildate all configs using Figaro
    def read_git_access_token
      user_home_dir = File.expand_path('~')
      git_access_config_file = YAML.load_file(File.join("#{user_home_dir}", 'test_data/QA/git_access.yaml'))
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
        File.join(@swagger.basePath, @operation.path)
      end

      def verb
        @operation.verb
      end

      def responses
        @operation.responses
      end
    end
  end
