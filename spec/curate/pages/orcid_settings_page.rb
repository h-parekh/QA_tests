# frozen_string_literal: true

module Curate
  module Pages
    class OrcidSettingsPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'orcid_settings')
      end

      def valid_page_content?
        page.has_content?("ORCID Settings")
        page.has_selector?(:link_or_button, "ORCID Settings")
        page.has_selector?(:link_or_button, "Open Researcher and Contributor ID (ORCID)")
        page.has_selector?(:link_or_button, "Create or Connect your ORCID iD")
      end
    end
  end
end
