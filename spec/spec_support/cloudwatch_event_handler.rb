# frozen_string_literal: true
require 'aws-sdk'

module CloudwatchEventHandler
  def self.set_aws_config
    if ENV.fetch('SKIP_CLOUDWATCH', false)
      Bunyan.current_logger.debug(context:'Cloudwatch skipped')
      return true
    end
    target_aws_account = 'testlibnd'
    aws_env_config_file = YAML.load_file(File.join(ENV.fetch('HOME'), 'test_data/QA/aws_config.yaml'))
    Aws.config.update({region: aws_env_config_file.fetch("#{target_aws_account}").fetch("default_region_name")})
    Aws.config.update({credentials: Aws::Credentials.new(aws_env_config_file.fetch("#{target_aws_account}").fetch("aws_access_key_id"), aws_env_config_file.fetch("#{target_aws_account}").fetch("aws_secret_access_key"))})
    Bunyan.current_logger.debug(context: 'AWS Cloudwatch Config set')
  end

  def self.report_json_result(output_hash:)
    return true if ENV.fetch('SKIP_CLOUDWATCH', false)
    client = Aws::CloudWatchEvents::Client.new
    rspec_result_event = {entries:[{"source": "testcontroller01","detail_type": "rspec_result","detail": output_hash.to_json}]}
    client.put_events(rspec_result_event)
  end
end
