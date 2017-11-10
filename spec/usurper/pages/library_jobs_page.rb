# frozen_string_literal: true
module Usurper
  module Pages
    # /personal
    class LibraryJobsPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
        correct_content? &&
        on_valid_url?
      end

      def correct_content?
        page.has_css?('h2', text: 'Employment')
        page.has_link?('Office of Human Resources, Employment Opportunities')
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, "employment/") || current_url == File.join(Capybara.app_host, "employment/#")
      end
    end
  end
end
