# frozen_string_literal: true
module WebRenovation
  module Pages
    # /
    class BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL
      attr_reader :username

      def initialize(username="")
        @username = username
      end

      def on_page?
        status_response_ok? &&
          valid_page_content?
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        within('#banner') do
          find_link('Hesburgh Libraries').visible?
        end

        find_link('Home').visible? &&
          find_link('Research').visible? &&
          find_link('Services').visible? &&
          find_link('Libraries & Centers').visible? &&
          find_link('About').visible? &&
          find('.login').visible? &&
          find_link('Search').visible? &&
          find_link('Ask Us').visible?

        within('#footer-info') do
          find_link(:href => '/page/hours/', :class =>'hours')
        end
      end
    end
  end
end
