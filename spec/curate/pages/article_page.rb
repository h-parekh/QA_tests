# frozen_string_literal: true

module Curate
  module Pages
    class ArticlePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
          on_valid_url? &&
          status_response_ok? &&
          valid_page_content? &&
          hasInputFields?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'concern/articles/new')
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        has_content?("Describe Your Article")
      end

      def hasInputFields?
        has_field?("article[title]")
        has_css?("div.control-group.text.required.article_abstract")
        has_field?("article[rights]")
      end
    end
  end
end
