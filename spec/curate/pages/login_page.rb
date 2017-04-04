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

      def initialize(logger)
        @current_logger = logger
        userNumber = Random.rand(1..5)
        current_user = 0
        CSV.foreach(ENV['HOME']+"/test_data/QA/TestCredentials.csv") do |row|
          if current_user == userNumber
            @userName = row[0]
            @passWord = row[1]
            @passCode = row[2]
          end
          current_user = current_user+1
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
