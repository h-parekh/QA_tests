# frozen_string_literal: true

module Sipity
  module Pages
    class NewDepositPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'areas/etd/start')
      end

      def valid_page_content?
        has_css?("div.control-group.text.required.submission_window_title")
        type_dropdown = find("select[name='submission_window[work_type]']")
        type_dropdown.has_content?("Doctoral Dissertation")
        type_dropdown.has_content?("Master's Thesis")
        publish_buttons = find("div.control-group.radio_buttons.required.submission_window_work_publication_strategy")
        publish_buttons.has_content?("Yes")
        publish_buttons.has_content?("No")
        publish_buttons.has_content?("I have already published portions of this work")
        publish_buttons.has_content?("Undecided")
        access_buttons = find("div.control-group.radio_buttons.required.submission_window_access_rights_answer")
        access_buttons.has_content?('Public')
        access_buttons.has_content?('Registered')
        access_buttons.has_content?('Private')
        access_buttons.has_content?('Embargoed')
        find("input[value='Create Work']")
      end
    end
  end
end
