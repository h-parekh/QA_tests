# frozen_string_literal: true

module Sipity
  module Pages
    class SubmittedETDPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == 'https://curate.nd.edu/catalog?f_inclusive%5Bhuman_readable_type_sim%5D%5B%5D=Doctoral+Dissertation&f_inclusive%5Bhuman_readable_type_sim%5D%5B%5D=Master%27s+Thesis'
      end

      def valid_page_content?
        # Sipity site behavior is such that user has to click login button
        # again to logged in after getting redirected to curate
        within('header.catalog.page-banner') do
          find('.login').click
          find("div.btn-group.my-actions").click
        end
        has_content?("My Works")
        has_content?("Group Administration")
        has_content?("My Account")
        has_content?("Log Out")
      end
    end
  end
end
