# frozen_string_literal: true
require 'seaside/seaside_spec_helper'

module Seaside
  module Pages
    class AboutPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
          has_images? &&
          has_links? &&
          on_valid_url?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, "about") || File.join(Capybara.app_host, "about#")
      end

      def has_images?
        within('.main') do
          all('figure.image', count: 3).each do |image|
            image.visible?
          end
        end
      end

      def has_links?
        within('.main') do
          find_link('Seaside, about the community', href: '/essays/the-community-and-building-the-portal') &&
            find_link('Seaside History', href: '/essays/seaside-history') &&
            find_link('Oral Histories', href: '/essays/oral-histories')
        end
      end
    end
  end
end
