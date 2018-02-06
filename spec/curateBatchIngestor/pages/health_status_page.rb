# frozen_string_literal: true
module CurateBatchIngestor
  module Pages
    class HealthStatusPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == Capybara.app_host || current_url == File.join(Capybara.app_host, '/')
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        page.has_content?(version_number_from_git_repo)
      end

      def version_number_from_git_repo
        url_to_version_file = 'https://raw.githubusercontent.com/ndlib/curatend-batch/master/version.go'
        version_file = open(url_to_version_file).read
        version_file.match(/[\d\.]+/)[0]
      end
    end
  end
end
