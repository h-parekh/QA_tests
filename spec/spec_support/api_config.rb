# frozen_string_literal: true

module ApiConfig
  @application_name_under_test = "testapi"
  @tmp_path_to_swagger_def = File.expand_path("../../../tmp/swagger_definitions/#{@application_name_under_test}_swagger.yaml", __FILE__)
  @path_to_spec_directory = File.expand_path('../../', __FILE__)
  @environment_under_test = "prod"
  @git_project_name = "test_api"

  def self.copy_remote_swagger_config(config: ENV)
    url_to_swagger_def = File.join("https://raw.githubusercontent.com/ndlib", @git_project_name, "/master/definitions/swagger.yaml")
    open(@tmp_path_to_swagger_def, 'wb') do |file|
      file << open(url_to_swagger_def).read
    end
  end

  def self.swagger_object
    initialize_target_env
    @swagger_object = Swagger.load(@tmp_path_to_swagger_def)
    Airborne.configure do |config|
      config.base_url = File.join(@env_url, @swagger_object.basePath)
    end
    return @swagger_object
  end

  def self.initialize_target_env
    servers_by_environment = YAML.load_file(
      File.expand_path("./#{@application_name_under_test}/#{@application_name_under_test}_config.yml", @path_to_spec_directory)
    )
    @env_url = servers_by_environment.fetch(@environment_under_test)
  end
end
