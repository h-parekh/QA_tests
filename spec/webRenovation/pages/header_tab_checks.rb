# frozen_string_literal: true
module WebRenovation
  module Pages
    # /personal
    class HeaderChecks < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
        correct_content?
      end

      def correct_content?
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
        end
        within('.menu-drawer.visible') do
          find('h4', text:'People')
          find('h4', text:'Spaces')
          find('h4', text:'Leadership')
        end
      end


    end
  end
end
