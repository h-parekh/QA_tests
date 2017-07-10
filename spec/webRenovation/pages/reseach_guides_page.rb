
module WebRenovation
  module Pages
    class ResearchGuidesPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def initialize
        last_opened_window = page.driver.browser.window_handles.last
        page.driver.browser.switch_to_window(last_opened_window)
      end

      def on_page?
        correct_content? &&
        on_valid_url?
      end

      def on_valid_url?
        #Link to the libcal reserve library spaces page
        libcal_research_guides = ('http://libguides.library.nd.edu/')
        current_url == libcal_research_guides
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
