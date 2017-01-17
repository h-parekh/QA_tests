# frozen_string_literal: true
require 'sipity/sipity_spec_helper'

describe 'ETDs area' do
  feature 'User Browsing', js: true do
    scenario 'Visit Homepage' do
      visit '/'
      current_logger.debug(context: "Assuming Sipity homepage redirects to ETD area")
      expect(page.current_path).to eq('/areas/etd')
      expect(page).to have_css('.btn.btn-primary', text: 'Start an ETD Submission')
      expect(page).to have_css('.btn.btn-primary', text: 'View Submitted ETDs')

      current_logger.info(context: "Verifying 'View Submitted ETDs' sends us to CurateND's search") do
        find_link('View Submitted ETDs').click
        expect(page.current_url).to match(%r{^https://[^\\]*curate[^\\]*/catalog})
        expect(page).to have_css('.search-constraints .filter-value', text: "Doctoral Dissertation OR Master's Thesis")
      end
    end
  end
end
