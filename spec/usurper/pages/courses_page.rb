# frozen_string_literal: true
module Usurper
  module Pages
    # /personal
    class CoursesPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
        on_valid_url? &&
        correct_content?
      end

      def correct_content?
        page.has_link?("My Items") &&
        page.has_link?("Log Out") &&
        find('h1', text: "Courses")
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, "courses") || current_url == File.join(Capybara.app_host, "courses#")
      end
    end
  end
end
