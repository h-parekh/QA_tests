require 'csv'
require 'curate/curate_spec_helper'
module Curate
  module Pages
    class LoginPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL
      attr_reader :userName
      attr_reader :passWord
      attr_reader :passCode
      attr_reader :current_logger
      attr_reader :account_details_updated_flag

      def initialize(logger, account_details_updated_flag)
        @account_details_updated_flag = account_details_updated_flag[:account_details_updated?].to_s
        @current_logger = logger
        credentials = CSV.read(ENV['HOME']+"/test_data/QA/TestCredentials.csv")
        # Filtering out items that satisfy the value of account_details_updated_flag
        flagged_credentials = credentials.select{|entry| entry[3] == account_details_updated_flag[:account_details_updated?].to_s}
        #randomly selecting a value from the remaining entries
        credentials_to_use = flagged_credentials.sample
        @userName = credentials_to_use[0]
        @passWord = credentials_to_use[1]
        @passCode = credentials_to_use[2]
      end

      def completeLogin
        visit '/'
        click_on('Log In')
        fill_in('username', with: userName)
        fill_in('password', with: passWord)
        find('[name=submit]').click
        # wait for first step of login to complete
        sleep(3)
        fill_in('passcode', with: passCode)
        find('[name=submit]').click
        # wait for second step of login to complete
        sleep(6)
        current_logger.info(context: "Logging in user: #{userName}")
      end

      def checkLoginPage
        page.has_content?("Login to Curate")
        find('#password')
        find('button[name="submit"]', :text => 'LOGIN')
      end
    end
  end
end