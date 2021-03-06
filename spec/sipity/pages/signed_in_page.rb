# frozen_string_literal: true

module Sipity
  module Pages
    class SignedInPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        valid_page_content? &&
          on_valid_url?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'areas/etd')
      end

      def valid_page_content?
        within('div.navbar-work') do
          has_css?('svg.CurateND-logo')
        end
        within('div.collapse.navbar-collapse') do
          has_content?('DASHBOARD')
          has_content?('SIGN OUT')
        end
        has_content?('Electronic Thesis and Dissertation')
        find_link('Start an ETD Submission')
        find_link('View Submitted ETDs')
        find("select[name='work_area[processing_state]']")
        find("input[value='Filter']")
        table = find("table.table")
        table.has_content?("Title")
        table.has_content?("Creator(s)")
        table.has_content?("Program Name(s)")
        table.has_content?("Type")
        table.has_content?("Processing State")
        table.has_content?("Date Created")
      end
    end
  end
end
