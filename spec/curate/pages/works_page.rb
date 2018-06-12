# frozen_string_literal: true

module Curate
  module Pages
    class MyWorksPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'catalog?f%5Bgeneric_type_sim%5D%5B%5D=Work&works=mine')
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        within('div.applied-constraints') do
          has_content?("Work")
        end
        has_selector?('li.active-item', text: 'My Works')
      end
    end
  end
end
