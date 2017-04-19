# frozen_string_literal: true
module Curate
  module Pages
    class ETDWelcomePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == Capybara.app_host+'account'
      end

      def status_response_ok?
        status_code.to_s.match(/^20[0,1,6]$/)
      end

      def valid_page_content?
        has_content?('Welcome to the ETD Submission System powered by CurateND')
        find("input[name='account[preferred_name]']")
        find("input[name='account[agreed_to_terms_of_service]']")
      end
    end
  end
end
