# frozen_string_literal: true
require 'seaside/seaside_spec_helper'

module Seaside
  module Pages
    class HistoryPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
          valid_page_content? &&
          on_valid_url?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'essays/seaside-history') || File.join(Capybara.app_host, "essays/seaside-history#")
      end

      def valid_page_content?
        within('.main') do
          find('.banner.with-subtitle').visible? &&
            find_link(href: '/essays/visions-of-seaside').visible? &&
            find_link(href: '/essays/the-artfulness-of-community-making').visible? &&
            all('figure.image', count: 2)
        end
      end
    end
  end
end
