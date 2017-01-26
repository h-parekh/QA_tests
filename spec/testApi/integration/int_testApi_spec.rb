# frozen_string_literal: true
require 'psych'
require 'testApi/testApi_spec_helper'

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
    url_to_swagger_def = File.join('https://raw.githubusercontent.com/', project_user_name, project_repository_name, 'master', 'definitions', 'swagger.yaml')
    swagger_yaml = open(url_to_swagger_def).read
    @swagger = Swagger.build(swagger_yaml, format: :yaml)
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

describe 'API tests using swagger definition' do
  SwaggerHandler.operations(for_file_path: __FILE__).each do |operation|
    it "calls #{operation.verb} #{operation.path}" do
      result = public_send(operation.verb, operation.url)
      expect(result.code.to_s).to eq(operation.responses.keys[0])
      expect_json_types(message: :string)
    end
  end
end
