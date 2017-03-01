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
        site = DaveSite.new
        current_url == site.current_url_for_view_type
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
        bottomBar = find('div[class^="DigitalArtifact__bottomBar"]')
        within(bottomBar) do
          url = DaveSite.new.button_link_url(page: "1")
          find('select') &&
          find("a[href='#{url}']")
        end
      end
      def check_scroll_buttons?
        wrapper = find('div[class^="Drawer__wrapper"]')
        within(wrapper) do
          find('button[class*="Drawer__left"]') &&
          find('button[class*="Drawer__right"]')
        end
      end
      def check_metadata?
        metaData = find('div[class^="Metadata__wrapper"]')
        within(metaData) do
          has_content?('Label') &&
          has_content?('Description') &&
          has_content?('License')
        end
      end
      def two_page?
        metaData = find('div[class^="Metadata__wrapper"]')
        within(metaData) do
          has_content?('left') &&
          has_content?('right') &&
          has_content?('Label') &&
          has_content?('Description') &&
          has_content?('License')
        end
      end
      def detail_view?
        metaData = find('div[class^="Metadata__wrapper"]')
        has_no_field?(metaData) &&
        check_manipulation_buttons? &&
        check_nav_buttons?
      end
      def check_manipulation_buttons?
        mButtons = find('ul[class^="OpenSeaDragonControls__controls"]')
        within(mButtons) do
          find("a[id='zoom-in']") &&
          find("a[id='zoom-out']") &&
          find("a[id='rotate-left']") &&
          find("a[id='rotate-right']") &&
          find("a[id='full-page']") &&
          has_content?("find-replace")
        end
      end
      def check_nav_buttons?
        find("div[class^='OpenSeaDragonPrevNext__rightNav']") &&
        find("div[class^='OpenSeaDragonPrevNext__leftNav']") &&
        find("div[class^='OpenSeaDragonToolbar__hoverSpin']")
      end

    end
  end
end
