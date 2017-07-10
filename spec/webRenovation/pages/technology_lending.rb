module WebRenovation
  module Pages
    class TechnologyLendingPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
        correct_content? &&
        on_valid_url? 
      end

      def on_valid_url?
        current_url == (Capybara.app_host + 'technology-lending')
      end
      def correct_content?
        within('.container-fluid.content-area') do
          page.has_css?('h2', text:'Technology and Miscellaneous Equipment Lending')
          page.has_css?('h3', text: 'Contact Info', minimum: 1)
        end
      end
    end
  end
end
