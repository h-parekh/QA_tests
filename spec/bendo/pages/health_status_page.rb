# frozen_string_literal: true

module Bendo
  module Pages
    class HealthStatusPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == Capybara.app_host || current_url == File.join(Capybara.app_host, '/')
      end

      def valid_page_content?
        page.has_content?("Bendo")
      end
    end
  end
end
