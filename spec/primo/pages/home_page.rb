# frozen_string_literal: true

module Primo
  module Pages
    class HomePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def initialize
        VerifyNetworkTraffic.exclude_uri_from_network_traffic_validation.push('/PDSMExlibris.css')
      end

      def on_page?
        on_valid_url? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, '/primo-explore/search?vid=NDU&sortby=rank&lang=en_US')
      end

      def valid_page_content?
        find_field(id: 'searchBar')
      end
    end
  end
end
