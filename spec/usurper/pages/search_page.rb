# frozen_string_literal: true

module Usurper
  module Pages
    class SearchPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def initialize
        @one_search_url = 'http://onesearch.library.nd.edu/primo_library/libweb/action/dlSearch.do?bulkSize=10&dym=true&highlight=true&indx=1&institution=NDU&mode=Basic&onCampus=false&pcAvailabiltyMode=true&query=any%2Ccontains%2Cundefined&search_scope=malc_blended&tab=onesearch&vid=NDU&displayField=title&displayField=creator'
        @nd_catlog_search_url = 'http://onesearch.library.nd.edu/primo_library/libweb/action/dlSearch.do?bulkSize=10&dym=true&highlight=true&indx=1&institution=NDU&mode=Basic&onCampus=false&pcAvailabiltyMode=true&query=any%2Ccontains%2Cundefined&search_scope=nd_campus&tab=nd_campus&vid=NDU&displayField=title&displayField=creator'
      end

      def on_page?
        sleep(2)
        valid_url? &&
          correct_content? &&
          valid_status?
      end

      def valid_url?
        current_url == @one_search_url ||
          current_url == @nd_catlog_search_url
      end

      def correct_content?
        page.has_selector?('#exlidUserAreaRibbon') &&
          page.has_selector?('#exlidMainMenuRibbon') &&
          page.has_selector?('.tab.onesearch.EXLSearchTabTitle.EXLSearchTabLABELOneSearch') &&
          page.has_selector?('.tab.ndcatalog.EXLSearchTabTitle.EXLSearchTabLABELND.Campus') &&
          page.has_selector?('#goButton') &&
          if current_url == @nd_catlog_search_url
            page.has_selector?('#showMoreOptions') &&
              page.has_selector?('.EXLSearchFieldMaximized.srch-box')
          else
            page.has_selector?('.EXLSearchFieldMaximized.long.EXLSearchFieldMaximized.srch-box')
          end
      end

      def valid_status?
        status_code == 200
      end
    end
  end
end
