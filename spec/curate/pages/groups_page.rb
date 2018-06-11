# frozen_string_literal: true

module Curate
  module Pages
    class MyGroupsPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'hydramata/groups')
      end

      def valid_page_content?
        has_content?("My Groups")
        has_selector?(:link_or_button, "Create Group")
      end
    end
  end
end
