# frozen_string_literal: true

module Curate
  module Pages
    class DocumentPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content? &&
          has_input_fields?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'concern/documents/new')
      end

      def valid_page_content?
        has_content?("Describe Your Document")
      end

      def has_input_fields?
        has_field?("document[title]")
        has_field?("document[rights]")
        has_field?("document[type]")
      end
    end
  end
end
