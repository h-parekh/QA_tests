# frozen_string_literal: true

module Usurper
  module Pages
    # /events calander page
    class CalendarPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def initialize
        last_opened_window = page.driver.browser.window_handles.last
        page.driver.browser.switch_to_window(last_opened_window)
      end

      def on_page?
        correct_content? &&
          correct_url? &&
          status_response_ok?
      end

      def status_response_ok?
        status_code == 200
      end

      def correct_content?
        page.has_selector?('.btn.dropdown-toggle.btn-default.btn-sm') && # Calendar library filter  dropdown
          page.has_selector?('.btn.dropdown-toggle.bs-placeholder.btn-default.btn-sm') && # Category filter dropdown
          page.has_selector?('#s-lc-c-search') && # Search for event form input
          page.has_selector?('.input-group-btn') && # Search button
          page.has_selector?('table.s-lc-mc') # Table of Calendar dates
      end

      def correct_url?
        page.current_url == 'http://nd.libcal.com/calendar/allworkshops/?cid=447&t=m&d=0000-00-00&cal=447'
      end
    end
  end
end
