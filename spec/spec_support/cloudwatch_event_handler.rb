# frozen_string_literal: true
require 'aws-sdk'

module CloudwatchEventHandler
  def self.set_aws_config
    target_aws_account = 'testlibnd'

    user_home_dir = File.expand_path('~')
    aws_env_config_file = YAML.load_file(File.join("#{user_home_dir}", 'test_data/QA/aws_config.yaml'))
    require 'byebug'; debugger
    Aws.config.update({region: aws_env_config_file.fetch("#{target_aws_account}").fetch("default_region_name")})
    Aws.config.update({credentials: Aws::Credentials.new(aws_env_config_file.fetch("#{target_aws_account}").fetch("aws_access_key_id"), aws_env_config_file.fetch("#{target_aws_account}").fetch("aws_secret_access_key"))})
  end
end
