module WebRenovation
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
          page.has_css?('h2', text:'Subjects')
        end
      end
    end
  end
end
