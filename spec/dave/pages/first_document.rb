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
        true
        #status_code == [0 || 200]
      end

      def valid_page_content?
        check_bottom_bar? &&
        check_scroll_buttons? &&
        check_metadata?
      end
      def check_bottom_bar?
        within('.DigitalArtifact__bottomBar___2iYjT') do
          url = SITE_URL[56..-2]+"1"
          find('select') &&
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
      def two_page?
        within('.Metadata__wrapper___2D0bL') do
          has_content?('left') &&
          has_content?('right') &&
          has_content?('Label') &&
          has_content?('Description') &&
          has_content?('License')
        end
      end
      def detail_view?
        has_no_field?('.Metadata__wrapper___2D0bL') &&
        check_manipulation_buttons? &&
        check_nav_buttons?
      end
      def check_manipulation_buttons?
        within("ul.OpenSeaDragonControls__controls___11q-d") do
          find("a[id='zoom-in']") &&
          find("a[id='zoom-out']") &&
          find("a[id='rotate-left']") &&
          find("a[id='rotate-right']") &&
          find("a[id='full-page']") &&
          has_content?("find-replace")
        end
      end
      def check_nav_buttons?
        find(".OpenSeaDragonPrevNext__rightNav___sP-F6") &&
        find(".OpenSeaDragonPrevNext__leftNav___2faHI") &&
        find(".OpenSeaDragonToolbar__hoverSpin___DlmyN material-icons")
      end

    end
  end
end
