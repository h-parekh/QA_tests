# frozen_string_literal: true

module XUR
  module Pages
    class HomePage
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
        status_code.to_s.match(/^20[0,1,6]$/)
      end

      def valid_page_content?
        within('#welcome') do
          find_link('Log in with netID (ND users)', href: '/login')
          find_link('Log in with email (non-ND)', href: '/email_login')
        end
      end
    end
  end
end
