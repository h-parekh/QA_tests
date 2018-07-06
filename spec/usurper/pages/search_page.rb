# frozen_string_literal: true

module Usurper
  module Pages
    class SearchPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def initialize
        VerifyNetworkTraffic.exclude_uri_from_network_traffic_validation.push('/primo-explore/config_NDUA.js', '/PDSMExlibris.css')
        @onesearch_url_regex = /http.*:\/\/onesearch.*.library.nd.edu\/primo-explore.*/
      end

      def on_page?
        correct_content? &&
          valid_url?
      end

      # If a match is found, the `=~` operator returns index of first match in string, otherwise it returns nil
      # @see https://ruby-doc.org/core-2.1.1/Regexp.html
      def valid_url?
        (current_url =~ @onesearch_url_regex).nil? ? false : true
      end

      def correct_content?
        page.has_selector?('#mainResults')
        within('#facets') do
          page.has_content?('Sort by')
          page.has_content?('Availability')
          page.has_content?('Publication Date')
          page.has_content?('Resource Type')
        end
      end
    end
  end
end
