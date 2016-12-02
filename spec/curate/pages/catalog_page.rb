# frozen_string_literal: true
module Curate
  module Pages
    # /catalog
    class CatalogPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      attr_reader :search_term, :category

      LOOKUP_CATEGORY_URL = {
        thesis: "/catalog?f_inclusive%5Bhuman_readable_type_sim%5D%5B%5D=Doctoral+Dissertation&f_inclusive%5Bhuman_readable_type_sim%5D%5B%5D=Master%27s+Thesis",
        article: "/catalog?f%5Bhuman_readable_type_sim%5D%5B%5D=Article",
        dataset: "/catalog?f%5Bhuman_readable_type_sim%5D%5B%5D=Dataset"
      }.freeze
      LOOKUP_CATEGORY_CAPTION = {
        thesis: "Theses & Dissertations",
        article: "Articles & Publications",
        dataset: "Datasets & Related Materials"
      }.freeze
      LOOKUP_CATEGORY_VALUE = {
        thesis: "Doctoral Dissertation OR Master's Thesis",
        article: "Article",
        dataset: "Dataset"
      }.freeze

      def initialize(search_term: nil, category: nil)
        @search_term = search_term
        @category = category
      end

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content? &&
          valid_search_constraint?
      end

      def on_valid_url?
        if category.nil? && search_term.nil?
          current_url.start_with?(File.join(Capybara.app_host, 'catalog'))
        elsif category.nil?
          current_url.start_with?(File.join(Capybara.app_host, 'catalog')) &&
            current_url.include?(search_term)
        else
          current_url == File.join(Capybara.app_host, LOOKUP_CATEGORY_URL.fetch(category))
        end
      end

      def on_base_url?
        current_url == File.join(Capybara.app_host, 'catalog')
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        within('.sidebar') do
          return false unless has_content?('Filter by:')
        end

        return true if category.nil?

        within('h1') do
          has_content?(LOOKUP_CATEGORY_CAPTION.fetch(category))
        end
      end

      def valid_search_constraint?
        return true if search_term.nil? && category.nil?

        within('.search-constraint-notice') do
          return false unless has_content?('Search criteria:')
        end

        within('.filter-value') do
          return false unless has_content?(filter_value)
        end

        return true if category.nil?

        within('.filter-name') do
          return false unless has_content?('Type of Work:')
        end

        true
      end

      def filter_value
        return LOOKUP_CATEGORY_VALUE.fetch(category) unless category.nil?
        search_term
      end
    end
  end
end
