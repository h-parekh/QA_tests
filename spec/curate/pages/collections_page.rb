# frozen_string_literal: true

module Curate
  module Pages
    class MyCollectionsPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'catalog?f%5Bgeneric_type_sim%5D%5B%5D=Collection&works=mine')
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        within('div.applied-constraints') do
          has_content?("Collection")
        end
        has_checked_field?('works_mine')
      end
    end
  end
end
