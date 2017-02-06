# frozen_string_literal: true
module Vatican
  module Pages
    class InstructionsPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'using')
      end

      def status_response_ok?
        status_code == 0 || 200
      end

      def valid_page_content?
        page.has_content?("How To Use the Database")
      end
    end
  end
end
