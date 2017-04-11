# frozen_string_literal: true
module WebRenovation
  module Pages
    # /personal
    class AccountPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super && on_valid_url?

        find_button("My Courses")

        page.assert_selector("button", text: "Renew", minimum: 1)
        page.assert_selector("p", text: "Due Date", minimum: 1)
        find_button("View in ILL").visible?
      end

      def on_valid_url?
        puts current_url
        current_url == (Capybara.app_host + "/personal")
      end

    end
  end
end
