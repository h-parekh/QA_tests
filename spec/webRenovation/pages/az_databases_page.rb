# frozen_string_literal: true
module WebRenovation
  module Pages
    # /personal
    class AZDatabases < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
        correct_content?

      end

      def correct_content?
        page.has_selector?(".alphabet")
        page.has_css?('h2', text:'Databases: A')
      end

    end
  end
end
