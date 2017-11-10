module Usurper
  module Pages
    class HoursPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
        correct_content? &&
        correct_url?
      end

      def correct_content?
        page.has_selector?('.location', text: 'Hesburgh Library')
        page.has_selector?('.location', text: 'Engineering Library')
        page.has_selector?('.location', text: 'O\'Meara Mathematics Library')
        page.has_selector?('.location', text: 'Medieval Institute Library')
        page.has_selector?('.location', text: 'Rare Books & Special Collections')
        page.has_selector?('.location', text: 'Chemistry-Physics Library')
        page.has_selector?('.location', text: 'Visual Resources Center')
        page.has_selector?('.location', text: 'Architecture Library')
        page.has_selector?('.location', text: 'Radiation Chemistry Reading Room')
        page.has_selector?('.location', text: 'Mahaffey Business Library')
        page.has_selector?('.location', text: 'Kellogg Kroc Library')
      end

      def correct_url?
        current_url == File.join(Capybara.app_host, "hours") || current_url == File.join(Capybara.app_host, "hours#")
      end
    end
  end
end
