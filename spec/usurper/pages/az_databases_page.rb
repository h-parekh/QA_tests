# frozen_string_literal: true

module Usurper
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
        within('.container-fluid.content-area') do
          page.has_selector?(".alphabet")
          page.has_css?('h1', text: 'Databases: A')
        end
      end
    end
  end
end
