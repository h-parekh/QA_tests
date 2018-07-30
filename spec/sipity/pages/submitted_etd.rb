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
        find('.btn.btn-primary.login').click
        find("div.btn-group.my-actions").click
        find("div.btn-group.my-actions.open")
        has_content?("My Works")
        has_content?("My Collections")
        has_content?("My Groups")
        has_content?("My Profile")
        has_content?("Log Out")
      end
    end
  end
end
