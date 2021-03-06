# frozen_string_literal: true

module Curate
  module Pages
    class OrcidHomePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content? &&
          valid_uri_parameters?
      end

      def on_valid_url?
        Capybara.current_host.include?('orcid.org')
      end

      def valid_page_content?
        page.has_content?("ORCID")
      end

      def valid_uri_parameters?
        # Since we're not testing the full use case of redirecting back after ORCID sign in,
        # these assertions provide a certain degree of validation that the site fires a correct redirect URL
        hostname_to_redirect = URI.parse(Capybara.app_host).host
        redirect_url_to_check = 'redirect_uri=https%3A%2F%2F' + hostname_to_redirect + '%2Forcid%2Fcreate_orcid'
        current_url.include?(redirect_url_to_check)
        current_url.include?('response_type=code')
        current_url.include?('scope=%2Fread-limited+%2Factivities%2Fupdate')
      end
    end
  end
end
