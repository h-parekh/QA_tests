# frozen_string_literal: true
module WebRenovation
  module Pages
    # /personal
    class CoursesPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super && on_valid_url?

        find_button("My Items").visible?

        page.assert_selector("a", text: "LibGuide", minimum: 1)
        page.assert_selector("a", text: "Reserves", minimum: 1)
      end

      def on_valid_url?
        puts current_url
        current_url == (Capybara.app_host + "/courses")
      end

    end
  end
end
