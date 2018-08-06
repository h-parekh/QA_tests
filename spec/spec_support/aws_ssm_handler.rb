# frozen_string_literal: true

require 'aws-sdk'

module AwsSsmHandler
  def self.set_ssm_client
    return true if ENV.fetch('SKIP_AWS_SSM_SETUP', false)
    if ENV['RUNNING_ON_LOCAL_DEV'] == "true"
      if !ENV['AWS_SECURITY_TOKEN'].nil?
        # This means that the user has already set AWS security token using one
        # of the CLI tools from aws or aws-vault. I can directly create a
        # credentials object from them
        call_create_creds_from_credentials
        create_ssm_client_from_env_variables
      else
        # This means that I need to route the user through a `assume role` setup
        # process based on their personal access keys
        Aws.config.update(
          region: ENV['region '].strip,
          credentials: Aws::Credentials.new(ENV['aws_access_key_id '].strip, ENV['aws_secret_access_key '].strip)
        )
        create_sts_client_for_user
        call_assume_role
        create_ssm_client_for_assumed_role
      end
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

  def self.create_ssm_client_from_env_variables
    @ssm_client = Aws::SSM::Client.new(region: ENV['AWS_REGION'], credentials: @role_credentials)
  end

  # Creates a credentials object for the assumed role
  # @return [Aws::Credentials]
  # @see https://docs.aws.amazon.com/sdkforruby/api/Aws/Credentials.html
  def self.call_create_creds_from_credentials
    @role_credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'], ENV['AWS_SECURITY_TOKEN'])
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
