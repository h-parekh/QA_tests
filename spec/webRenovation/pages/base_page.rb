module WebRenovation
  module Pages
    class BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        status_response_ok? &&
          valid_page_content? &&
          valid_navigation? &&
          has_hours?
      end

      def status_response_ok?
        status_code == 200
      end

      def has_hours?
        within('.header-hours') do
          hoursLink = page.find_link(href: '/page/hours/')
          hoursLink.text.should_not == ""
        end
      end

      def valid_page_content?
        within('#banner') do
          find_link('Hesburgh Libraries').visible?
        end

        within('#footer-info') do
          find_link(href: '/page/hours/', :class =>'hours')
        end
      end

      def valid_navigation?
        find_link('Home').visible? &&
          find_link('Research').visible? &&
          find_link('Services').visible? &&
          find_link('Libraries & Centers').visible? &&
          find_link('About').visible? &&
          find('.login').visible? &&
          find_link('Search').visible? &&
          find_link('Ask Us').visible?
      end
    end
  end
end
