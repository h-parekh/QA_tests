# frozen_string_literal: true

module CurateBatchIngestor
  module Pages
    class JobsStatusPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_response?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'jobs')
      end

      def status_response_ok?
        status_code == 200
      end

      # Batch ingestor's /jobs page returns an array of hashes
      # This assertion verifies that the response has non-zero elements,
      # and also verifies that each hash element has valid keys
      def valid_response?
        response_array = JSON.parse(page.text)
        if response_array.count > 0
          response_array.all? { |each_hash|
            each_hash.has_key?("Name")
            each_hash.has_key?("Status") }
        else
          return false
        end
      end
    end
  end
end
