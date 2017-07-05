# frozen_string_literal: true
module WebRenovation
  module Pages
    # /personal
    class LibraryGivingPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
        on_valid_url?
      end

      def on_valid_url?
        last_opened_window = page.driver.browser.window_handles.last
        page.driver.browser.switch_to_window(last_opened_window)
        current_url == ('http://librarygiving.nd.edu/')
      end
    end
  end
end
