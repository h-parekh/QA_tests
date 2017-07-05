
module WebRenovation
  module Pages
    class ResearchGuidesPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
        on_valid_url? &&
        correct_content?
      end

      def on_valid_url?
        #Link to the libcal reserve library spaces page
        libcal_research_guides = ('http://libguides.library.nd.edu/')
        last_opened_window = page.driver.browser.window_handles.last
        page.driver.browser.switch_to_window(last_opened_window)
        current_url == libcal_research_guides
      end

    def correct_content?
      within('.s-lib-public-body') do
        find_by_id('s-lg-index-all-btn')
        find_by_id('s-lg-index-guidetype-btn')
        find_by_id('s-lg-index-subject-btn')
        find_by_id('s-lg-index-owner-btn')
        find_by_id('s-lg-guide-search')
      end
    end

    end
  end
end
