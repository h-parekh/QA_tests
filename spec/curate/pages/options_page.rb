# frozen_string_literal: true

module Curate
  module Pages
    class StartDepositPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'deposit')
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        has_content?('DEPOSIT') &&
          has_content?('What are you uploading') &&
          has_content?('Audio') &&
          has_content?('Senior Thesis') &&
          find('.add-button.btn.btn-primary.add_new_article') &&
          find('.add-button.btn.btn-primary.add_new_audio') &&
          find('.add-button.btn.btn-primary.add_new_dataset') &&
          find('.add-button.btn.btn-primary.add_new_document') &&
          find('.add-button.btn.btn-primary.add_new_image') &&
          find('.add-button.btn.btn-primary.add_new_senior_thesis')
      end
    end
  end
end
