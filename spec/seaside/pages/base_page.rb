# frozen_string_literal: true
require 'seaside/seaside_spec_helper'

module Seaside
  module Pages
    class BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        status_response_ok? &&
          valid_top_banner? &&
          valid_bottom_banner?
      end

      def status_response_ok?
        status_code == 200 || status_code == 304
      end

      def valid_top_banner?
        within('.page-navigation') do
          find_link('About Seaside').visible? &&
            find_link('Planning Seaside').visible? &&
            find_link('Building Seaside').visible? &&
            find_link('Interactive Map').visible? &&
            find('.q.search-field').visible? &&
            find('.search-button').visible?
        end
      end

      def valid_bottom_banner?
        within('.wrapper') do
          find('h4', text: 'THE SEASIDE RESEARCH PORTAL').visible? &&
            find_link('Hesburgh Libraries').visible? &&
            find_link('School of Architecture').visible? &&
            find_link('About the Portal').visible? &&
            find_link('Terms of Use').visible? &&
            find_link('Request an Image').visible? &&
            find_link('Seaside, Florida').visible? &&
            find_link('University of Notre Dame').visible? &&
            find('figure.mark').visible?
        end
      end
    end
  end
end
