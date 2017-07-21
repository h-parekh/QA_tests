# frozen_string_literal: true
require 'csv'

class LoginPage
  include Capybara::DSL
  include CapybaraErrorIntel::DSL
  attr_reader :userName
  attr_reader :passWord
  attr_reader :passCode
  attr_reader :current_logger
  attr_reader :account_details_updated

  # When logging this file, we do not want to accidentally log the passwords
  #
  # @return [String] anonymized details of the user details (e.g. skip passwords)
  def inspect
    "#<#{self.class} @userName=#{userName.inspect} @account_details_updated=#{account_details_updated.inspect}>"
  end
  alias to_s inspect

  def initialize(logger, account_details_updated: (updated_set = false), terms_of_service_accepted: (accepted = true))
    @account_details_updated = account_details_updated
    @terms_of_service_accepted = terms_of_service_accepted
    @current_logger = logger
    credentials = CSV.read(ENV['HOME']+"/test_data/QA/TestCredentials.csv")
    # To remove the header (first element in the array) while maintaining array type
    # so sample method is still available
    credentials.shift
    # Filtering out items that satisfy the value of @account_details_updated if specified)
    # updated_set will only be nil if test specifies account_details_updated in initialization
    if updated_set == nil
      flagged_credentials = credentials.select{ |entry| cast_to_boolean(entry[3]) == @account_details_updated }
      # randomly selecting a value from the remaining entries
      credentials_to_use = flagged_credentials.sample
    elsif accepted == nil
      flagged_credentials = credentials.select{ |entry| cast_to_boolean(entry[4]) == @terms_of_service_accepted }
      # randomly selecting a value from the remaining entries
      credentials_to_use = flagged_credentials.sample
    else
      # randomly selecting a value from the remaining entries
      credentials_to_use = credentials.sample
    end
    @userName = credentials_to_use[0]
    @passWord = credentials_to_use[1]
    @passCode = credentials_to_use[2]
  end

  def account_details_updated
    @account_details_updated
  end

  def cast_to_boolean(value)
    case value
    when /^[TY]/i, '1'
      true
    else
      false
    end
  end

  def completeLogin
    page.has_selector?('#username [name=username]')
    page.has_selector?("#password [name=password]")
    page.has_selector?('.form-signin [name=submit]')
    fill_in('username', with: userName)
    fill_in('password', with: passWord)
    find('.form-signin [name=submit]').trigger('click')
    page.has_selector?("input[name=passcode]")
    fill_in('passcode', with: passCode)
    page.has_selector?('.form-signin [name=submit]')
    find('.form-signin [name=submit]').trigger('click')
    current_logger.info(context: "Logging in user: #{userName}")
    # waits for it to leave the login page
    page.has_no_selector?('.form-signin [name=submit]')
  end
end
