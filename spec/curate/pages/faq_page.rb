# frozen_string_literal: true

module Curate
  module Pages
    # /faqs
    class FaqPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content? &&
          valid_page_navigation? &&
          valid_external_page_links?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'faqs')
      end

      def valid_page_content?
        within('.svg-title') do
          has_content?('FAQ')
        end
      end

      def valid_page_navigation?
        within(".feature-navigation-wrapper") do
          find_link('Help').visible? &&
            find_link('Getting Started').visible? &&
            find_link('Common Questions').visible?
        end
      end

      def valid_external_page_links?
        valid_policy_page_links? &&
          valid_help_button?
      end

      def valid_policy_page_links?
        # note: policies is an id tag... see http://www.rubydoc.info/github/jnicklas/capybara/Capybara%2FSession%3Awithin
        within(:xpath, "//h2[@id='policies']") do
          find_link('Governing policies').visible?
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
