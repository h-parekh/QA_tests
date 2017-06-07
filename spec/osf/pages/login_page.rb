# frozen_string_literal: true
require 'csv'
require 'osf/osf_spec_helper'

module OSF
  module Pages
    class LoginPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL
      attr_reader :userName
      attr_reader :passWord
      attr_reader :passCode
      attr_reader :current_logger
      attr_reader :account_details_updated

      def inspect
        "#<#{self.class} @userName=#{userName.inspect}>"
      end

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
        require 'byebug'; debugger
        visit '/'
        click_on('Sign In')
        within('#fm1') do
          click_on('#alternative-institution')
        end
        click_on('#institution-form-select')
        click_on('option' ,text: 'University of Notre Dame')
        find('input[name=submit]').click
        page.has_selector?("input[name=username]")
        page.has_selector?("input[name=password]")
        page.has_selector?('.form-signin [name=submit]')
        fill_in('username', with: userName)
        fill_in('password', with: passWord)
        find('.form-signin [name=submit]').click
        # wait for first step of login to complete
        page.has_selector?("input[name=passcode]")
        fill_in('passcode', with: passCode)
        # wait for second step of login to complete
        page.has_selector?('.form-signin [name=submit]')
        find('.form-signin [name=submit]').trigger('click')
        current_logger.info(context: "Logging in user: #{userName}")
        sleep(10)
      end

      def checkLoginPage
        page.has_content?("Login to Open Science Foundation")
        find('#password')
        find('button[name="submit"]', :text => 'LOGIN')
      end
    end
  end
end
