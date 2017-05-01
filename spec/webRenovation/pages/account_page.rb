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

        page.assert_selector("button", text: "RENEW", minimum: 1)
        page.assert_selector("button", text: "VIEW IN ILL", minimum: 1)
        page.assert_selector("div", text: "Due Date", minimum: 1)
      end

      def on_valid_url?
        puts current_url
        current_url == (Capybara.app_host + "/personal")
      end

    end
  end
end
