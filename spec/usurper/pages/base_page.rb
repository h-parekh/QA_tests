# frozen_string_literal: true

module Usurper
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
          valid_footer? &&
          valid_version?
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
          find_by_id('research').trigger('click')
          menu_drawer_has_content?
          find_by_id('services').trigger('click')
          menu_drawer_has_content?
          find_by_id('libraries').trigger('click')
          menu_drawer_has_content?
          find_by_id('about').trigger('click')
          menu_drawer_has_content?
          # need to close 'About' tab or issues randomly pop up
          find('a', id: 'about').trigger('click')
          if @loggedin
            find('.m', text: 'MY ACCOUNT')
          else
            find_link('Login')
          end
          find_link('Hours', href: '/hours').visible?
        end
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

      def valid_version?
        # I could have done this implementation with find_by_id("nd-version"),
        # but that approach does not let me assert on the version number in the 'content' attribute
        # of meta tags. That's because Capybara does not support :content option in it's have_selector? method
        # So I'm using string interpolation to assert on the entire selector
        # Reference: https://stackoverflow.com/questions/12801463/capture-and-assert-meta-tags-in-rspec
        # Reference: https://joanswork.com/rspec-test-specific-meta-tag-content/
        expected_version = ENV['VERSION_NUMBER']
        version_meta_tag = "meta[id=\"nd-version\"][content=\"#{expected_version}\"]"
        find(version_meta_tag, visible: false)
      end

      # This is a generic method to validate that each of the menu subdrawers for
      # 'Research', 'Services', 'Libraries' and 'About' menu links have valid columns and links.
      # This approach loosens the assertion because it only checks for existence, but is
      # more maintainable since the text and links will keep changing in Contentful
      def menu_drawer_has_content?
        within('.menu-drawer.visible') do
          all('.col-md-3').each do
            all('li').any?
          end
        end
      end
    end
  end
end
