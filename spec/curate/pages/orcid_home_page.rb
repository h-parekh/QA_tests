# frozen_string_literal: true
module Curate
  module Pages
    class OrcidHomePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url.include?('orcid.org')
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        page.has_content?("ORCID")
        page.has_selector?(:link_or_button, "Register now")
        page.has_selector?(:link_or_button, "Sign into ORCID")
      end
    end
  end
end
