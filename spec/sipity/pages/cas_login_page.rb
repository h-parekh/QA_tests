# frozen_string_literal: true

require 'csv'
module Sipity
  module Pages
    class CASLoginPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def initialize(logger, terms_of_service_accepted: false)
        @terms_of_service_accepted = terms_of_service_accepted
        @current_logger = logger
        credentials = CSV.read(ENV['HOME'] + "/test_data/QA/TestCredentials.csv")
        # Filtering out items that satisfy the value of @terms_of_service_accepted
        flagged_credentials = credentials.select { |entry| cast_to_boolean(entry[4]) == @terms_of_service_accepted }
        # randomly selecting a value from the remaining entries
        credentials_to_use = flagged_credentials.sample
        @user_name = credentials_to_use[0]
        @pass_word = credentials_to_use[1]
        @pass_code = credentials_to_use[2]
      end

      def terms_of_service_accepted
        @terms_of_service_accepted
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

      def complete_login
        fill_in('username', with: @user_name)
        fill_in('password', with: @pass_word)
        find('[name=submit]').click
        # wait for first step of login to complete
        page.has_selector?("input[name=passcode]")
        fill_in('passcode', with: @pass_code)
        # wait for second step of login to complete
        page.has_selector?("input[name=submit]")
        find('[name=submit]').click
        @current_logger.info(context: "Logging in user: #{@user_name}")
        sleep(10)
      end
    end
  end
end
