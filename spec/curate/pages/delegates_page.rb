# frozen_string_literal: true

module Curate
  module Pages
    class MyDelegatesPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
          on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url.include? 'depositors'
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        has_content?("Manage Your Delegates")
        has_content?("Grant Delegate Access")
        has_content?("Authorized Delegates")
      end
    end
  end
end
