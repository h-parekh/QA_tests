# frozen_string_literal: true

require 'csv'

class LoginPage
  include Capybara::DSL
  include CapybaraErrorIntel::DSL
  attr_reader :user_name
  attr_reader :password
  attr_reader :passcode
  attr_reader :current_logger
  attr_reader :account_details_updated

  # When logging this file, we do not want to accidentally log the passwords
  #
  # @return [String] anonymized details of the user details (e.g. skip passwords)
  def inspect
    "#<#{self.class} @user_name=#{user_name.inspect} @account_details_updated=#{account_details_updated.inspect}>"
  end
  alias to_s inspect

  def initialize(logger, account_details_updated: (updated_set = false), terms_of_service_accepted: (accepted = true))
    @account_details_updated = account_details_updated
    @terms_of_service_accepted = terms_of_service_accepted
    @current_logger = logger
    credentials = Psych.load(AwsSsmHandler.get_param_from_parameter_store("/all/qa/testing_netids")).to_a
    # Filtering out items that satisfy the value of @account_details_updated if specified)
    # updated_set will only be nil if test specifies account_details_updated in initialization
    if updated_set.nil?
      flagged_credentials = credentials.select { |entry| entry[1]["CurateAccountDetailsUpdated"] == @account_details_updated }
      # randomly selecting a value from the remaining entries
      credentials_to_use = flagged_credentials.sample
    elsif accepted.nil?
      flagged_credentials = credentials.select { |entry| entry[1]["SipityTermsOfServiceUpdated"] == @terms_of_service_accepted }
      # randomly selecting a value from the remaining entries
      credentials_to_use = flagged_credentials.sample
    else
      # randomly selecting a value from the remaining entries
      credentials_to_use = credentials.sample
    end
    @user_name = credentials_to_use[0]
    @password = credentials_to_use[1]["Password"]
    @passcode = credentials_to_use[1]["Passcode"]
  end

  def cast_to_boolean(value)
    case value
    when /^[TY]/i, '1'
      true
    else
      false
    end
  end

  def complete_login
    page.has_selector?('.form-signin [name=submit]')
    fill_in('username', with: user_name)
    fill_in('password', with: password)
    find('.form-signin [name=submit]').click
    page.has_content?('Welcome to the new Notre Dame login process')
    page.driver.browser.switch_to.frame('duo_iframe')
    find('#passcode').click
    page.has_selector?("input[name=passcode]")
    fill_in('passcode', with: passcode)
    current_logger.info(context: "Logging in user: #{user_name}")
    find('button.positive.auth-button', text: 'Log In').click
    page.has_no_content?('Welcome to the new Notre Dame login process')
    current_logger.info(context: "Logged in user: #{user_name} SUCCESFULLY")
  end

  def on_page?
    on_valid_url? &&
      status_response_ok? &&
      valid_page_content?
  end

  def on_valid_url?
    current_url.start_with?('https://login.nd.edu/cas/login')
  end

  def status_response_ok?
    status_code.to_s.match(/^20[0,1,6]$/)
  end

  def valid_page_content?
    page.has_content?("Central Authentication Service")
    find('#password')
    find('#username')
  end
end
