# frozen_string_literal: true

module Curate
  module Pages
    class ArticlePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content? &&
          has_input_fields?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'concern/articles/new')
      end

      def valid_page_content?
        has_content?("Describe Your Article")
      end

      def has_input_fields?
        has_field?("article[title]")
        has_css?("div.control-group.text.required.article_abstract")
        has_field?("article[rights]")
      end
    end
  end
end
