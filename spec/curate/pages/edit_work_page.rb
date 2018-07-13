# frozen_string_literal: true

module Curate
  module Pages
    class EditWorkPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url.include? 'edit'
      end

      def valid_page_content?
        has_content?("Manage Your Work")
      end

      def has_editable_doi?
        within('#doi') do
          has_content?('Digital Object Identifier')
          find_link(href: /http.*:\/\/.*datacite.org\/doi:.*\/.*/)
        end
        # Checks if an editable text box exists
        find('#image_doi')
      end
    end
  end
end
