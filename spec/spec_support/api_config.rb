# frozen_string_literal: true

module ApiConfig
  def self.set_airborne_config
    Airborne.configure do |config|
      initialize
      config.base_url = 'http://testcontroller02.library.nd.edu:5602' + @api.basePath
    end
  end

  def self.initialize
    url_to_swagger_def = 'https://raw.githubusercontent.com/ndlib/test_api/master/definitions/swagger.yaml'
    tmp_path_to_swagger_def = File.expand_path("../../../tmp/swagger_definitions/swagger.yaml", __FILE__)
    open(tmp_path_to_swagger_def, 'wb') do |file|
      file << open(url_to_swagger_def).read
    end
    @api = Swagger.load(tmp_path_to_swagger_def)
  end
end
