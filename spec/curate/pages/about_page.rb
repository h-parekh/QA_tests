# frozen_string_literal: true
module Curate
  module Pages
    # /about
    class AboutPage
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
        current_url == File.join(Capybara.app_host, 'about')
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        has_content?('ABOUT')
      end

      def valid_page_navigation?
        within(".feature-navigation-wrapper") do
          find_link('Manage').visible? &&
            find_link('Preserve').visible? &&
            find_link('Discover').visible? &&
            find_link('Share').visible?
        end
      end

      def valid_links?
        valid_deposit_links? &&
          valid_help_button?
      end

      def valid_deposit_links?
        all(".emphatic-action-wrapper a").count.eql?(4)
      end

      def valid_help_button?
        within(".page-footer-wrapper") do
          find_link('Help').visible?
        end
      end
    end
  end
end
