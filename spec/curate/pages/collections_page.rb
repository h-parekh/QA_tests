# frozen_string_literal: true

module Curate
  module Pages
    class MyCollectionsPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content? &&
          valid_links
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'catalog?f%5Bgeneric_type_sim%5D%5B%5D=Collection&works=mine')
      end

      def valid_page_content?
        within('div.applied-constraints') do
          has_content?("Collection")
        end
        has_selector?('li.active-item', text: 'My Collections')
      end

      def valid_links
        within('.search-query-list') do
          find_link('My Collections')
          find_link('All Collections')
        end
      end
    end
  end
end
