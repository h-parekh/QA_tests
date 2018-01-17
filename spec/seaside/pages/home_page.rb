# frozen_string_literal: true
require 'seaside/seaside_spec_helper'

module Seaside
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
        current_url == Capybara.app_host
      end

      def status_response_ok?
        status_code.to_s.match(/^20[0,1,6]$/)
      end

      def valid_page_content?
        within('.page-navigation') do
          has_link?('About Seaside') &&
            has_link?('Planning Seaside') &&
            has_link?('Building Seaside') &&
            has_link?('Interactive Map') &&
            has_field?('.q.search-field') &&
            has_field?('.search-button')
        end

        within('.featured-content') do
          has_link?(href: '/360/index.html') &&
            has_link?(href: '/permalink/ARCH-SEASIDE:4008') &&
            has_link?(href: '/permalink/ARCH-SEASIDE:2')
        end
      end
    end
  end
end
