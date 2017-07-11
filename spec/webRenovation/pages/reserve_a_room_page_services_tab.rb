# frozen_string_literal: true
module WebRenovation
  module Pages
    # /personal
    class RoomReservationServicesTabPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
        correct_content? &&
        on_valid_url?
      end

      def correct_content?
        page.has_css?('h2', text: 'Reserve a Meeting or Event Space')
        page.has_selector?('.librarian', minimum: 1)
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'room-reservations')
      end
    end
  end
end
