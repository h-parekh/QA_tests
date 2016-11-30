# frozen_string_literal: true
module Curate
  module Pages
    # /catalog
    class CatalogPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def initialize(search_term = '')
        @search_term = search_term
      end

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content? &&
          valid_search_constraint?
      end

      def on_valid_url?
        current_url.start_with?(File.join(Capybara.app_host, 'catalog')) &&
          current_url.include?(@search_term)
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        within('.sidebar') do
          has_content?('Filter by:')
        end
      end

      def valid_search_constraint?
        return true if @search_term.empty?
        within('.search-constraint-notice') do
          has_content?('Search criteria:')
        end &&
          within('.filter-value') do
            has_content?(@search_term)
          end
      end
    end
  end
end
