# frozen_string_literal: true

module Dave
  module Pages
    # /
    class FirstDocument
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content?
      end

      def on_valid_url?
        site = DaveSite.new
        current_url == site.current_url_for_view_type
      end

      def valid_page_content?
        check_bottom_bar? &&
          check_scroll_buttons? &&
          check_meta_data?
      end

      def check_bottom_bar?
        bottom_bar = find('div[class^="DigitalArtifact__bottomBar"]')
        within(bottom_bar) do
          url = DaveSite.new.button_link_url(page: "1")
          find('select') &&
            find("a[href='/#{url}']")
        end
      end

      def check_scroll_buttons?
        wrapper = find('div[class^="Drawer__wrapper"]')
        within(wrapper) do
          find('button[class*="Drawer__left"]') &&
            find('button[class*="Drawer__right"]')
        end
      end

      def check_meta_data?
        meta_data = find('div[class^="Metadata__content"]')
        within(meta_data) do
          has_content?('Label') &&
            has_content?('Description') &&
            has_content?('License')
        end
      end

      def two_page?
        meta_data = find('div[class^="Metadata__content"]')
        within(meta_data) do
          has_content?('left') &&
            has_content?('right') &&
            has_content?('Label') &&
            has_content?('Description') &&
            has_content?('License')
        end
      end

      def detail_view?
        find('div[class^="OpenSeaDragonPage__viewer"]') &&
          check_manipulation_buttons? &&
          check_nav_buttons?
      end

      def check_manipulation_buttons?
        has_content?("find_replace")
        m_buttons = find('ul[class^="OpenSeaDragonControls__controls"]')
        within(m_buttons) do
          find("a[id='zoom-in']") &&
            find("a[id='zoom-out']") &&
            find("a[id='rotate-left']") &&
            find("a[id='rotate-right']") &&
            find("a[id='full-page']") &&
            has_content?("find_replace")
        end
      end

      def check_nav_buttons?
        find("div[class^='OpenSeaDragonPrevNext__rightNav']") &&
          find("div[class^='OpenSeaDragonPrevNext__leftNav']") &&
          find("span[class^='OpenSeaDragonToolbar__hoverSpin']")
      end
    end
  end
end
