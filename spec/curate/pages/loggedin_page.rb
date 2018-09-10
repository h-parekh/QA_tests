# frozen_string_literal: true

module Curate
  module Pages
    class LoggedInHomePage < HomePage
      def initialize(login_page = {})
        @login_page = login_page
      end

      def on_page?
        super &&
          valid_logged_in_page_content? &&
          manage_dropdown? &&
          deposit_dropdown?
      end

      def valid_logged_in_page_content?
        find("div.btn-group.add-content") &&
          find("div.btn-group.my-actions")
      end

      def manage_dropdown?
        find("div.btn-group.my-actions").click
        find("div.btn-group.my-actions.open")
        has_content?("My Works")
        has_content?("Group Administration")
        has_content?("My Account")
        has_content?("Log Out")
        find("div.btn-group.my-actions").click
      end

      def account_details_updated?
        @login_page.account_details_updated
      end

      def deposit_dropdown?
        find("div.btn-group.add-content").click
        find("div.btn-group.add-content.open")
        has_content?("New Article")
        has_content?("New Dataset")
        has_content?("New Document")
        has_content?("New Image")
        has_content?("More Options")
        find("div.btn-group.add-content").click
      end

      def open_actions_drawer
        find("div.btn-group.my-actions").click
      end

      def open_add_content_drawer
        find("div.btn-group.add-content").click
      end
    end
  end
end
