# frozen_string_literal: true
module Curate
  module Pages
    # /
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
        current_url == Capybara.app_host
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        within('.homepage-search') do
          has_field?('catalog_search', type: 'search') &&
            find_button('keyword-search-submit').visible?
        end
      end

      def valid_logged_in_page_content?
        valid_page_content? &&
        find("div.btn-group.add-content") &&
        find("div.btn-group.my-actions")
      end

      def manageDropdown?
        find("div.btn-group.my-actions").click
        find("div.btn-group.my-actions.open")
        has_content?("My Works")
        has_content?("My Collections")
        has_content?("My Groups")
        has_content?("My Profile")
        has_content?("My Delegates")
        has_content?("Log Out")
        find("div.btn-group.my-actions").click
      end

      def depositDropdown?
        find("div.btn-group.add-content").click
        find("div.btn-group.add-content.open")
        has_content?("New Article")
        has_content?("New Dataset")
        has_content?("New Document")
        has_content?("New Image")
        has_content?("More Options")
        find("div.btn-group.add-content").click
      end
    end
  end
end
