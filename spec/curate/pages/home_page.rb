# frozen_string_literal: true

module Curate
  module Pages
    class HomePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
      end

      def on_logged_in_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_logged_in_page_content? &&
          manageDropdown? &&
          depositDropdown?
      end

      def on_valid_url?
        current_url == Capybara.app_host || current_url == File.join(Capybara.app_host, '/')
      end

      def status_response_ok?
        status_code.to_s.match(/^20[0,1,6]$/)
      end

      def valid_page_content?
        within('.homepage-search') do
          has_field?('catalog_search', type: 'search') &&
            find_button('keyword-search-submit').visible?
        end
      end
    end
  end
end
