# frozen_string_literal: true

module Curate
  module Pages
    class DatasetPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content? &&
          has_input_fields?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'concern/datasets/new')
      end

      def valid_page_content?
        has_content?("Describe Your Dataset")
      end

      def has_input_fields?
        has_field?("dataset[title]")
        has_css?("div.control-group.text.required.dataset_description")
        has_field?("dataset[rights]")
      end
    end
  end
end
