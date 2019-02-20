# frozen_string_literal: true

module Primo
  module Pages
    class SearchResultsPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL
      def on_page?
        on_valid_url? &&
          has_results?
      end

      def on_valid_url?
        # NOTE: This check skips matching URI
        !current_url.match(Capybara.app_host).nil?
      end

      def has_results?
        page.has_content?('Refine my results')
        !find_all('h3.item-title').empty?
      end
    end
  end
end
