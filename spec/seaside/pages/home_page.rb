# frozen_string_literal: true
require 'seaside/seaside_spec_helper'

module Seaside
  module Pages
    class HomePage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
          on_valid_url? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == Capybara.app_host || File.join(Capybara.app_host, '/')
      end

      def valid_page_content?
        within('.featured-content') do
          find_link(href: '/360/index.html').visible? &&
            find_link(href: '/permalink/ARCH-SEASIDE:4008').visible? &&
            find_link(href: '/permalink/ARCH-SEASIDE:2').visible?
        end
      end
    end
  end
end
