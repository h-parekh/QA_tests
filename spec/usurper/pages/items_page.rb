# frozen_string_literal: true
module Usurper
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
        page.has_link?('My Courses') &&
        page.has_link?("Log Out") &&
        find('h1', text: "Items & Requests").visible? &&
        find('h3', match: :smart, text: 'Checked Out').visible? &&
        find('h3', match: :smart, text: 'Pending').visible?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, "items-requests") || current_url == File.join(Capybara.app_host, "items-requests#")
      end

    end
  end
end
