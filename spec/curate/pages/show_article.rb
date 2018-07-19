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
          valid_page_content?
      end

      def on_valid_url?
        current_url.include? 'show'
      end

      # Not all articles have downloads. Don't fail in a bad way if that is the case
      def has_files?
        find("div.actions a.action.btn", text: "Download", match: :first)
        return true
      rescue Capybara::ElementNotFound
        false
      end

      def has_pagination?(page_var = "page")
        within("div.pager div.page_links") do
          find("li.prev-page")
          next_page = find("li.next-page a")
          # Also make sure it links with the correct page parameter
          return next_page['href'] =~ /.*[?&]#{page_var}=.*/
        end
        return true
      rescue Capybara::ElementNotFound
        false
      end

      def valid_page_content?
        has_content?(@article_title)
        # Make sure that the Abstract and Attributes sections have text
        within("article.abstract.descriptive-text") do
          page.has_selector?("p", minimum: 1)
        end
        within("table.table.table-striped.attributes") do
          first('p')
        end
      end

      def new_doi_minted_article?
        on_valid_url?
        has_content?('Your DOI for your work is being requested. It may take a few minutes to generate.')
        has_content?(@article_title)
        has_no_content?('Digital Object Identifier')
        within("table.table.table-striped.attributes") do
          first('p')
        end
      end

      def has_doi?
        has_content?('Digital Object Identifier')
        on_valid_url?
        find_link(href: /http.*:\/\/.*datacite.org\/doi:.*\/.*/)
      end
    end
  end
end
