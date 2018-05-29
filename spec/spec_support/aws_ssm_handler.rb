# frozen_string_literal: true

require 'aws-sdk'

module AwsSsmHandler
  def self.set_ssm_client
    if ENV['RUNNING_ON_LOCAL_DEV'] == "true"
      Aws.config.update(
        region: ENV['region '].strip,
        credentials: Aws::Credentials.new(ENV['aws_access_key_id '].strip, ENV['aws_secret_access_key '].strip)
      )
      create_sts_client_for_user
      call_assume_role
      create_ssm_client_for_assumed_role
    elsif ENV['RUNNING_ON_LOCAL_DEV'] == "false"
      call_create_creds_in_ecs
      create_ssm_client
    else
      puts "Missing RUNNING_ON_LOCAL_DEV in ENV"
      puts "Please pass `RUNNING_ON_LOCAL_DEV=true` if you're in dev/test mode"
      exit!
    end
  end

  # Creates a STS client based on developer's user profile to assume role
  # @return [Aws::STS::Client]
  def self.create_sts_client_for_user
    @sts_client = Aws::STS::Client.new
  end

  # Use the temporary credentials that AssumeRole returns to make a
  # connection to Parameter Store
  # @return [Aws::SSM::Client]
  # @see https://docs.aws.amazon.com/sdkforruby/api/Aws/SSM/Client.html
  def self.create_ssm_client_for_assumed_role
    @ssm_client = Aws::SSM::Client.new(region: ENV['region '].strip, credentials: @assumed_role_object)
  end

  # Calls the assume_role method of the STSConnection object @sts_client and
  # pass the role ARN, role session name, MFA device number and one time passcode
  # @return [Aws::STS::Types::AssumeRoleResponse]
  # @see https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRole.html
  def self.call_assume_role
    if !ENV['TOKEN_CODE'].nil?
      @assumed_role_object = @sts_client.assume_role(
        role_arn: ENV['role_arn '].strip,
        role_session_name: "AssumeRoleSession_local",
        serial_number: ENV['mfa_serial '].strip,
        token_code: ENV['TOKEN_CODE']
      )
    else
      puts "Missing value for `ENV['TOKEN_CODE']`."
      puts "Please pass MFA code as an environment variable in `TOKEN_CODE` and retry"
      exit!
    end
  end

  # Creates SSM client for AWS ECS
  # @return [Aws::SSM::Client]
  # @see https://docs.aws.amazon.com/sdkforruby/api/Aws/SSM/Client.html
  def self.create_ssm_client
    @ssm_client = Aws::SSM::Client.new(region: ENV['AWS_REGION'], credentials: @role_credentials)
  end

  # Creates a credentials object for the ECS executing role in AWS
  # @return [Aws::InstanceProfileCredentials]
  # @see https://docs.aws.amazon.com/sdkforruby/api/Aws/InstanceProfileCredentials.html
  def self.call_create_creds_in_ecs
    @role_credentials = Aws::InstanceProfileCredentials.new
  end

  def self.get_param_from_parameter_store(name)
    decrypted_param = @ssm_client.get_parameter(name: name.to_s, with_decryption: true)
    decrypted_param.parameter.value
  end
end
