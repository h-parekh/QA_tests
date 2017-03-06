module Curate
  module Pages
    class ThesisPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
          on_valid_url? &&
          status_response_ok? &&
          valid_page_content? &&
          hasInputFields?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'concern/senior_theses/new')
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        has_content?("Describe Your Senior Thesis")
      end

      def hasInputFields?
        has_field?("senior_thesis[title]")
        has_field?("senior_thesis[rights]")
        has_field?("senior_thesis[creator][]")
        has_css?("div.control-group.text.required.senior_thesis_description")
      end
    end
  end
end
