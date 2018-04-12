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
          status_response_ok? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, '/primo_library/libweb/action/search.do?vid=NDU')
      end

      def status_response_ok?
        status_code.to_s.match(/^20[0,1,6]$/)
      end

      def valid_page_content?
        within('#search_box') do
          find_field(id: 'search_field')
          find_button(id: 'goButton')
        end
      end

      def onesearch_tab_activated?
        # Check if the onesearch tab is selected
       find('a.active.tab.onesearch.EXLSearchTabTitle.EXLSearchTabLABELOneSearch')
      end

      def ndcatalog_tab_activated?
        # Check if the NDcatalog tab is selected
        find('a.active.tab.ndcatalog.EXLSearchTabTitle.EXLSearchTabLABELND.Campus')
      end
    end
  end
end
