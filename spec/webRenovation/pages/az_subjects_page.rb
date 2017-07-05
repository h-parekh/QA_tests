# frozen_string_literal: true
module WebRenovation
  module Pages
    # /personal
    class AZSubjects < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
        correct_content?
      end

      def correct_content?
        expect(page).to have_selector(".col-md-6", minimum: 2)
        expect(page).to have_css('h2', text:'Subjects')
      end

    end
  end
end
