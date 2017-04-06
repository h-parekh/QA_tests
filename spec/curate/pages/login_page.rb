# frozen_string_literal: true
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
      attr_reader :account_details_updated

      def initialize(logger, account_details_updated: false)
        @account_details_updated = account_details_updated
        @current_logger = logger
        credentials = CSV.read(ENV['HOME']+"/test_data/QA/TestCredentials.csv")
        # Filtering out items that satisfy the value of @account_details_updated
        flagged_credentials = credentials.select{ |entry| cast_to_boolean(entry[3]) == @account_details_updated }
        # randomly selecting a value from the remaining entries
        credentials_to_use = flagged_credentials.sample
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
