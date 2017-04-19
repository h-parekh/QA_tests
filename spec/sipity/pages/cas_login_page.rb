# frozen_string_literal: true

require 'csv'
module Curate
  module Pages
    class CASLoginPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

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
        page.has_content?("Login to Curate")
        find('#password')
        find('#username')
        find('button[name="submit"]', :text => 'LOGIN')
      end

      def completeLogin
        fill_in('username', with: @userName)
        fill_in('password', with: @passWord)
        find('[name=submit]').click
        # wait for first step of login to complete
        sleep(6)
        fill_in('passcode', with: @passCode)
        find('[name=submit]').click
        # wait for second step of login to complete
        @current_logger.info(context: "Logging in user: #{@userName}")
      end
    end
  end
end
