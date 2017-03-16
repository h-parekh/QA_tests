# frozen_string_literal: true
module WebRenovation
  module Pages
    # /
    class HomePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == Capybara.app_host
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        within('#wrapper') do
          find_link('University of Notre Dame').visible?
        end

        within('#banner') do
          find_link('Hesburgh Libraries').visible? &&
            find_link('Ask Us!!').visible?
        end

        find_link('Home').visible? &&
          find_link('Research').visible? &&
          find_link('Services').visible? &&
          find_link('Libraries & Centers').visible? &&
          find_link('About').visible? &&
          find_link('Log In').visible? &&
          find_link('Search').visible?
      end
    end
  end
end
