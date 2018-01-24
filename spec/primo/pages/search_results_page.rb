# frozen_string_literal: true

module Primo
  module Pages
    class SearchResultsPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL
      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          has_results?
      end

      def on_valid_url?
        # NOTE: This check skips matching URI
        !current_url.match(Capybara.app_host).nil?
      end

      def status_response_ok?
        status_code.to_s.match(/^20[0,1,6]$/)
      end

      def has_results?
        page.has_content?('LIMIT RESULTS BY')
        within('#resultsListNoId') do
          !find('table#exlidResultsTable').find_all('tr').empty?
        end
      end
    end
  end
end
