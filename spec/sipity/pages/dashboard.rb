# frozen_string_literal: true

module Sipity
  module Pages
    class Dashboard
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'dashboard')
      end

      def valid_page_content?
        find("select[name='processing_state']")
        find("input[value='Filter']")
        find_link('New Deposit')
        table = find("table.table")
        table.has_content?("Title")
        table.has_content?("Creator(s)")
        table.has_content?("Type")
        table.has_content?("Processing State")
        table.has_content?("Date Created")
      end
    end
  end
end
