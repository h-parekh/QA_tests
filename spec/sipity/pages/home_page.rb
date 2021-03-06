# frozen_string_literal: true

module Sipity
  module Pages
    class HomePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        valid_page_content? &&
          on_valid_url?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'areas/etd')
      end

      def valid_page_content?
        within('div.navbar-work') do
          has_css?('svg.CurateND-logo')
        end
        within('div.collapse.navbar-collapse') do
          has_content?('SIGN IN')
        end
        find_link('Start an ETD Submission')
        find_link('View Submitted ETDs')
        find_link('dteditor@nd.edu')[:href].start_with?('mailto')
        find_link('574-631-7545')[:href].start_with?('tel')
        find_link('Hesburgh Libraries of Notre Dame', href: 'http://library.nd.edu')
        find_link('University of Notre Dame', href: 'http://www.nd.edu')
        find_link(class: 'hesburgh-logo', href: 'http://library.nd.edu')
      end
    end
  end
end
