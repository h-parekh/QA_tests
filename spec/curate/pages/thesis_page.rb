# frozen_string_literal: true

module Curate
  module Pages
    class ThesisPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content? &&
          has_input_fields?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'concern/senior_theses/new')
      end

      def valid_page_content?
        has_content?("Describe Your Senior Thesis")
      end

      def has_input_fields?
        has_field?("senior_thesis[title]")
        has_field?("senior_thesis[rights]")
        has_field?("senior_thesis[creator][]")
        has_css?("div.control-group.text.required.senior_thesis_description")
      end
    end
  end
end
