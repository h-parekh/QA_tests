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
        visit '/'
        click_on('Sign In')
        page.has_selector?('#alternative-institution')
        find('#alternative-institution').click
        find('#institution-form-select').click
        page.has_field?('option' ,text: 'University of Notre Dame')
        page.select('University of Notre Dame')
        find('input[name=submit]').trigger(:click)
        page.has_selector?('#username [name=username]')
        page.has_selector?("#password [name=password]")
        page.has_selector?('.form-signin [name=submit]')
        fill_in('username', with: userName)
        fill_in('password', with: passWord)
        sleep(2)
        # wait for fill_in
        find('.form-signin [name=submit]').trigger('click')
        page.has_selector?("input[name=passcode]")
        fill_in('passcode', with: passCode)
        sleep(2)
        # wait for fill_in
        page.has_selector?('.form-signin [name=submit]')
        find('.form-signin [name=submit]').trigger('click')
        current_logger.info(context: "Logging in user: #{userName}")
      end

      def checkLoginPage
        page.has_content?("Login to Open Science Foundation")
        find('#password')
        find('button[name="submit"]', :text => 'LOGIN')
      end
    end
  end
end
