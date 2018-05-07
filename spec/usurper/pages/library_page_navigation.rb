# frozen_string_literal: true

module Usurper
  module Pages
    # /personal
    class LibraryPages < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
          on_valid_url?
      end

      def on_valid_url?
        last_opened_window = page.driver.browser.window_handles.last
        page.driver.browser.switch_to_window(last_opened_window)
        current_url.include?('https://www.google.com/maps/place/')
      end
    end
  end
end
