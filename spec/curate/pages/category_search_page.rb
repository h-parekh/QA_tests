# frozen_string_literal: true
module Curate
  module Pages
    # /catalog
    class CategorySearchPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      attr_reader :category

      LOOKUP_URL = {
        thesis: "/catalog?f_inclusive%5Bhuman_readable_type_sim%5D%5B%5D=Doctoral+Dissertation&f_inclusive%5Bhuman_readable_type_sim%5D%5B%5D=Master%27s+Thesis",
        article: "/catalog?f%5Bhuman_readable_type_sim%5D%5B%5D=Article",
        dataset: "/catalog?f%5Bhuman_readable_type_sim%5D%5B%5D=Dataset"
      }.freeze
      LOOKUP_CAPTION = {
        thesis: "Theses & Dissertations",
        article: "Articles & Publications",
        dataset: "Datasets & Related Materials"
      }.freeze
      LOOKUP_VALUE = {
        thesis: "Doctoral Dissertation OR Master's Thesis",
        article: "Article",
        dataset: "Dataset"
      }.freeze

      def initialize(category)
        @category = category
      end

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content? &&
          valid_search_constraint?
      end

      def on_valid_url?
        expected_url = File.join(Capybara.app_host, LOOKUP_URL.fetch(category))
        current_url == expected_url
      end

      def on_base_url?
        current_url == File.join(Capybara.app_host, 'catalog')
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        # Note: this should be found in the H2 row of main, but I couldn't get the right scope.
        # However, finding it on the page should be adequate.
        has_content?(category) &&
          within('.sidebar') do
            has_content?('Filter by:')
          end
      end

      def valid_search_constraint?
        within('.search-constraint-notice') do
          has_content?('Search criteria:')
        end &&
          within('.filter-name') do
            has_content?('Type of Work:')
          end &&
          within('.filter-value') do
            has_content?(LOOKUP_VALUE.fetch(category))
          end
      end
    end
  end
end
