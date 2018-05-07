module Usurper
  module Pages
    # / page for library workshops
    class WorkshopPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
          correct_content?
      end

      def correct_content?
        page.has_selector?('.librarian', minimum: 1) &&
          page.has_link?('Library Workshop Registration Portal')
      end
    end
  end
end
