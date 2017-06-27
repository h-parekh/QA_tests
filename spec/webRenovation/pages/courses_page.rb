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
        find_link("My Items").visible?
        page.assert_selector("a", text: "Course Guide", minimum: 1)
        page.assert_selector("a", text: "Course Reserves", minimum: 1)
      end

      def on_valid_url?
        current_url == (Capybara.app_host + "courses")
      end

    end
  end
end
