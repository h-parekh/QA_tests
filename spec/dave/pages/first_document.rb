# frozen_string_literal: true
module Dave
  module Pages
    # /
    class FirstDocument
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == SITE_URL
      end

      def status_response_ok?
        status_code == 0 || 200
      end

      def valid_page_content?
        check_bottom_bar? &&
        check_scroll_buttons? &&
        check_metadata?
      end
      def check_bottom_bar?
        within('.DigitalArtifact__bottomBar___2iYjT') do
          find('select') &&
          url = SITE_URL[56..-2]+"1"
          find("a[href='#{url}']")
        end
      end
      def check_scroll_buttons?
        within('.Drawer__wrapper___d9kg1') do
          find('button.Drawer__clickButton___3xD_G.Drawer__left___1TOLa') &&
          find('button.Drawer__clickButton___3xD_G.Drawer__right___bJI7C')
        end
      end
      def check_metadata?
        within('.Metadata__wrapper___2D0bL') do
          has_content?('Label') &&
          has_content?('Description') &&
          has_content?('License')
        end
      end
    end
  end
end
