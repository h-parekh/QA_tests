module Usurper
  module Pages
    class SearchPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def initialize
        @one_search_url = 'http://onesearch.library.nd.edu/primo_library/libweb/action/search.do?fn=search&ct=search&initialSearch=true&mode=Basic&tab=onesearch&indx=1&dum=true&srt=rank&vid=NDU&frbg=&tb=t&vl%28freeText0%29=&scp.scps=scope%3A%28hathi_pub%29%2Cscope%3A%28ndulawrestricted%29%2Cscope%3A%28dtlrestricted%29%2Cscope%3A%28NDU%29%2Cscope%3A%28NDLAW%29%2Cscope%3A%28ndu_digitool%29'
        @nd_catlog_search_url = 'http://onesearch.library.nd.edu/primo_library/libweb/action/search.do?fn=search&ct=search&initialSearch=true&mode=Basic&tab=nd_campus&indx=1&dum=true&srt=rank&vid=NDU&frbg=&tb=t&vl%28freeText0%29=&scp.scps=scope%3A%28hathi_pub%29%2Cscope%3A%28ndulawrestricted%29%2Cscope%3A%28dtlrestricted%29%2Cscope%3A%28NDU%29%2Cscope%3A%28NDLAW%29%2Cscope%3A%28ndu_digitool%29'
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
