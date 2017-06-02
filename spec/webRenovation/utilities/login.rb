require 'csv'
# frozen_string_literal: true
module WebRenovation
  module Utilities
    class Login
      include Capybara::DSL
      include CapybaraErrorIntel::DSL
      attr_reader :username
      attr_reader :password
      attr_reader :passcode
      attr_reader :current_logger

      def initialize(logger)
        @current_logger = logger
        userNumber = Random.rand(1..5)
        current_user = 0
        CSV.foreach(ENV['HOME']+"/test_data/QA/TestCredentials.csv") do |row|
          if current_user == userNumber
            @username = row[0]
            @password = row[1]
            @passcode = row[2]
          end
          current_user = current_user+1
        end
      end

      def completeLogin
        find('.login').click
        fill_in('username', with: username)
        fill_in('password', with: password)
        find('[name=submit]').click
        # wait for first step of login to complete
        page.has_selector?("input[name=passcode]")
        fill_in('passcode', with: passcode)
        # wait for second step of login to complete
        page.has_selector?("input[name=submit]")
        find('[name=submit]').click
        current_logger.info(context: "Logging in user: #{username}")
        sleep(10)
      end
    end
  end
end
