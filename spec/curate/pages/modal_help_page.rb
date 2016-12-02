# frozen_string_literal: true
module Curate
  module Pages
    # /help
    class ModalHelpPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        status_response_ok? &&
          modal_window_visible?
      end

      def status_response_ok?
        status_code == 200
      end

      def modal_window_visible?
        find('#ajax-modal').visible? &&
          has_field?('help_request_name', type: 'text') &&
          has_field?('help_request_email', type: 'email') &&
          has_field?('help_request_how_can_we_help_you', type: 'textarea')
      end
    end
  end
end
