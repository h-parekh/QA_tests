# frozen_string_literal: true
module WebRenovation
  module Pages
    # /
    class HomePage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super && on_valid_url?
      end

      def on_valid_url?
        current_url == Capybara.app_host
      end

    end
  end
end
