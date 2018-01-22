# frozen_string_literal: true
require 'seaside/seaside_spec_helper'

module Seaside
  module Pages
    class CommunityPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
          valid_page_content? &&
          on_valid_url?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'essays/the-community-and-building-the-portal') || File.join(Capybara.app_host, "the-community-and-building-the-portal#")
      end

      def valid_page_content?
        within('.article') do
          find('span.avoid-wrap', text: 'Seaside Research Portal').visible? &&
            find('h1', text: 'Seaside, about the community').visible? &&
            find('p.author').visible? &&
            find_link(href: 'assets/Seaside-FL-map-960.jpeg').visible? &&
            find('ul.timeline').visible? &&
            find('ol.footnotes').visible?
        end
      end
    end
  end
end
