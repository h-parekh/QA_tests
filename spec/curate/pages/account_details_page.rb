# frozen_string_literal: true
module Curate
  module Pages
    class AccountDetailsPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
          on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host,'users/edit')
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        has_content?("Account Details")
        has_selector?(:link_or_button, "Update My Account")
      end
    end
  end
end
