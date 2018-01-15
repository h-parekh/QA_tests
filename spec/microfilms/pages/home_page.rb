# frozen_string_literal: true

module Microfilms
  module Pages
    class HomePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == Capybara.app_host || current_url == File.join(Capybara.app_host, '/')
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        find('h2', text: 'About Searching')
        within('.search') do
          find_field('q', type: 'text')
          find_button('search')
        end
        within('.facets') do
          find_link('Format')
          find_link('Library')
          find_link('City')
          find_link('Country of Origin')
          find_link('Collection')
          find_link('Language')
          find_link('Date Range')
          find_link('Illuminations')
          find_link('Musical Notation')
          find_link('Commentary Volume')
          find_link('Type of Text')
        end
      end
    end
  end
end
