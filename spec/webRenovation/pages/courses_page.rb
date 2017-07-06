# frozen_string_literal: true
module WebRenovation
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
        find_link("My Items").visible? &&
        find_link("Log Out").visible? &&
        find('h2', text: "Courses")
      end

      def on_valid_url?
        current_url == (Capybara.app_host + "courses")
      end

    end
  end
end
