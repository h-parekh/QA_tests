module WebRenovation
  module Pages
    class TechnologyLendingPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
        on_valid_url? &&
        correct_content?
      end

      def on_valid_url?
        current_url == (Capybara.app_host + 'technology-lending')
      end
      def correct_content?
        within('.container-fluid.content-area') do
          find('h2', text:'Technology and Miscellaneous Equipment Lending')
          find('h3', text: 'Contact Info', minimum: 1)
        end
        #expect(page).to have_css('h2', text:'Technology and Miscellaneous Equipment Lending')
        #expect(page).to have_css('h3', text:'Contact Info', minimum: 1)
      end
    end
  end
end
