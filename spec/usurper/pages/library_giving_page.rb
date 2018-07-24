# frozen_string_literal: true

module Usurper
  module Pages
    # /personal
    class LibraryGivingPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        correct_content? &&
          on_valid_url?
      end

      def correct_content?
        page.has_link?('Library Giving')
      end

      def on_valid_url?
        url_regex = /http.*:\/\/librarygiving.nd.edu.*/
        last_opened_window = page.driver.browser.window_handles.last
        page.driver.browser.switch_to.window(last_opened_window)
        (current_url =~ url_regex).nil? ? false : true
      end
    end
  end
end
