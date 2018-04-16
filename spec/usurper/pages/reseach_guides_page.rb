
module Usurper
  module Pages
    class ResearchGuidesPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def initialize
        VerifyNetworkTraffic.exclude_uri_from_network_traffic_validation.push('/svn/loader/run_prettify.js', '/libapps/sites/3767/include/img/jesus.gif')
        last_opened_window = page.driver.browser.window_handles.last
        page.driver.browser.switch_to_window(last_opened_window)
      end

      def on_page?
        correct_content? &&
        on_valid_url?
      end

      def on_valid_url?
        # Library guides Homepage redirects to 'By Subject' tab on load
        current_url == 'http://libguides.library.nd.edu/?b=s'
      end

    def correct_content?
      within('.s-lib-public-body') do
        page.has_selector?('#s-lg-index-all-btn')
        page.has_selector?('#s-lg-index-guidetype-btn')
        page.has_selector?('#s-lg-index-subject-btn')
        page.has_selector?('#s-lg-index-owner-btn')
        page.has_selector?('#s-lg-guide-search')
      end
    end

    end
  end
end
