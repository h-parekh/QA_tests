# frozen_string_literal: true

module Usurper
  module Pages
    class AZSubjects < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
          correct_content?
      end

      def correct_content?
        within('.container-fluid.content-area') do
          page.has_selector?(".col-md-6", minimum: 2)
          page.has_css?('h1', text: 'Subjects')
        end
      end
    end
  end
end
