# frozen_string_literal: true

module Curate
  module Pages
    class AccountDetailsPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'users/edit')
      end

      def valid_page_content?
        has_content?("Account Details")
        has_selector?(:link_or_button, "Update My Account")
        has_selector?(:link_or_button, "ORCID Settings")
      end
    end
  end
end
