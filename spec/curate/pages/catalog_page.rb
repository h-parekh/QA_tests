# frozen_string_literal: true
module Curate
  module Pages
    # /catalog
    class CatalogPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url.start_with? File.join(Capybara.app_host, 'catalog')
        p current_url
      end

      def status_response_ok?
        status_code == 200
        p status_code
      end

      def valid_page_content?
        has_content?('FAQ')
      end
    end
  end
end
