module WebRenovation
  module Pages
    class BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def initialize(loggedin: false)
        @loggedin = loggedin
      end

      def on_page?
        status_response_ok? &&
          valid_header? &&
          valid_footer?
      end

      def status_response_ok?
        status_code == 200 || status_code == 304
      end

      def valid_header?
        within('#banner') do
          find_link('Hesburgh Libraries', href: '/').visible?
        end
        within('.uNavigation') do
          find_link('Home', href: '/').visible?
        end
        within('.uNavigation') do
          find_by_id('research').trigger('click')
        end
        within('.menu-drawer.visible') do
          find('h4', text:'Research Support')
          find('h4', text:'Unique Collections')
        end
        within('.uNavigation') do
          find_by_id('services').trigger('click')
        end
        within('.menu-drawer.visible') do
          find('h4', text:'Technology and Spaces')
          find('h4', text:'Find, Borrow, Request')
          find('h4', text:'Teaching and Consulting')
        end
        within('.uNavigation') do
          find_by_id('libraries').trigger('click')
        end
        within('.menu-drawer.visible') do
          find('h4', text:'Hesburgh Libraries')
          find('h4', text:'Global Gateways')
          find('h4', text:'Area Libraries')
        end
        within('.uNavigation') do
          find_by_id('about').trigger('click')
          within('.menu-drawer.visible') do
            find('h4', text:'People')
            find('h4', text:'Spaces')
            find('h4', text:'Leadership')
          end
          # need to close 'About' tab or issues randomly pop up
          find_by_id('about').trigger('click')
        end
        within('.menu-link.user') do
          if @loggedin
            find('.m', text: 'MY ACCOUNT')
          else
            find_link('Login')
          end
        end
        find('a', id: 'header-search-button').visible?
        find_link('Hours', href: '/hours').visible?
      end

      def valid_footer?
        within('#footer-links') do
          find_link('Website Feedback').visible? &&
            find_link('Library Giving', href: 'http://librarygiving.nd.edu').visible? &&
            find_link('Jobs', href: '/employment/').visible? &&
            find_link('Hesnet', href: 'https://wiki.nd.edu/display/libintranet/Home').visible? &&
            find_link('NDLibraries', href: 'http://twitter.com/ndlibraries').visible? &&
            find_link('NDLibraries', href: 'https://www.facebook.com/NDLibraries/').visible?
        end

        within('#chat') do
          find('a.chat-button').visible?
        end
      end
    end
  end
end
