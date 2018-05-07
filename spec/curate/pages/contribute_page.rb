# frozen_string_literal: true

module Curate
  module Pages
    # /contribute
    class ContributePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content? &&
          valid_page_navigation? &&
          valid_links?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'contribute')
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        has_content?('CONTRIBUTING')
      end

      def valid_page_navigation?
        within(".contributing") do
          find_link('designated communities policy').visible? &&
            find_link('content in scope policy').visible? &&
            find_link('ORCID').visible?
        end
      end

      def valid_links?
        valid_deposit_links? &&
          valid_help_button?
      end

      def valid_deposit_links?
        within(".call-to-action") do
          find_link('Get Started').visible?
        end
      end

      def valid_help_button?
        within(".page-footer-wrapper") do
          find_link('Help').visible?
        end
      end
    end
  end
end
