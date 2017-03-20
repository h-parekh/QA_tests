module Curate
  module Pages
    class LoggedInHomePage < HomePage
      def on_page?
        super &&
        valid_logged_in_page_content? &&
        manageDropdown? &&
        depositDropdown?
      end

      def valid_logged_in_page_content?
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

      def openActionsDrawer
        find("div.btn-group.my-actions").click
      end

      def openAddContentDrawer
        find("div.btn-group.add-content").click
      end
    end
  end
end
