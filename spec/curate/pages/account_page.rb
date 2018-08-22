# frozen_string_literal: true

module Curate
  module Pages
    class MyAccountPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url.include? 'people'
      end

      def valid_page_content?
        has_selector?(:link_or_button, "Update Personal Information")
      end
    end
  end
end
