# frozen_string_literal: true
module WebRenovation
  module Pages
    # /personal
    class RoomReservationPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
        on_valid_url?
      end

      def on_valid_url?
        #Link to the libcal reserve library spaces page
        libcal_room_reservation = ('http://nd.libcal.com/#s-lc-box-2749-container-tab1')
        last_opened_window = page.driver.browser.window_handles.last
        page.driver.browser.switch_to_window(last_opened_window)
        current_url == libcal_room_reservation
      end

    end
  end
end
