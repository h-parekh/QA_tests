module WebRenovation
  module Pages
    class BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        status_response_ok? &&
          valid_header? &&
          valid_footer? &&
          valid_feedback_button?
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_header?
        within('#banner') do
          find_link('Hesburgh Libraries', href: '/').visible? &&
            find_link('Log In', href: '/personal').visible?
        end

        within('.uNavigation') do
          find_link('Home', href: '/').visible?
          # Add assertions for Research, Services, Libraries, About  and all their drawer buttons
          # Add assertions for search, ask us and hours
        end
      end

      def valid_footer?
        within('#footer-links') do
          find_link('Feedback', href: 'https://docs.google.com/a/nd.edu/forms/d/e/1FAIpQLSdL4MnInHvXcQke9dJQ1Idkv2O23u9dBV_9ky40WDOV77B_MA/viewform?c=0&w=1').visible? &&
            find_link('Library Giving', href: 'http://librarygiving.nd.edu').visible? &&
            find_link('Jobs', href: '/employment/').visible? &&
            find_link('Hesnet', href: 'https://wiki.nd.edu/display/libintranet/Home').visible? &&
            find_link('NDLibraries', href: 'http://twitter.com/ndlibraries').visible? &&
            find_link('NDLibraries', href: 'https://www.facebook.com/NDLibraries/').visible?
        end

        within('#chat') do
          find('a.chat-button')
        end
      end

      def valid_feedback_button?
        within('.feedback-notice-me') do
          find_link('SUBMIT FEEDBACK', href: 'https://docs.google.com/a/nd.edu/forms/d/e/1FAIpQLSdL4MnInHvXcQke9dJQ1Idkv2O23u9dBV_9ky40WDOV77B_MA/viewform?c=0&w=1').visible?
        end
      end
    end
  end
end
