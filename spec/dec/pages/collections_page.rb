# frozen_string_literal: true
module Dec
  module Pages
    class CollectionsPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
        end

        def on_valid_url?
          current_url == File.join(Capybara.app_host)
        end
    end
  end
end
