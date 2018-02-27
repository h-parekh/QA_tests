# frozen_string_literal: true
module Curate
  module Pages
    class ShowArticlePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      attr_reader :article_title

      def initialize(title: '')
        @article_title = title
      end

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url.include? 'show'
      end

      def status_response_ok?
        status_code == 200
      end

      # Not all articles have downloads. Don't fail in a bad way if that is the case
      def has_files?
        begin
          find("div.actions a.action.btn", text: "Download", match: :first)
          return true
        rescue Capybara::ElementNotFound
          false
        end
      end

      def has_pagination?(page_var = "page")
        begin
          within("div.pager div.page_links") do
            find("li.prev-page")
            next_page = find("li.next-page a")
            # Also make sure it links with the correct page parameter
            return next_page['href'] =~ (/.*[?&]#{page_var}=.*/)
          end
          return true
        rescue Capybara::ElementNotFound
          false
        end
      end

      def valid_page_content?
        has_content?(@article_title)
        # Make sure that the Abstract and Attributes sections have text
        within("article.abstract.descriptive-text") do
          page.has_selector?("p", minimum: 1)
        end
        within("table.table.table-striped") do
          first('p')
        end
      end
    end
  end
end
