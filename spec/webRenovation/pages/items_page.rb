# frozen_string_literal: true
module WebRenovation
  module Pages
    # /personal
    class ItemsPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
        on_valid_url? &&
        correct_content?
      end

      def correct_content?
        page.has_link?('My Courses')
        find_link("Log Out").visible? &&
        find('h2', text: "Items & Requests")
        find('h3', text: 'Checked out')
        find('h3', text: 'Pending')
      end

      def on_valid_url?
        current_url == (Capybara.app_host + "personal")
      end

    end
  end
end
