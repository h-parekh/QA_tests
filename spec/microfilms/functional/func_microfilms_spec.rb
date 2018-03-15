# frozen_string_literal: true

require 'microfilms/microfilms_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Loads Home Page', :smoke_test, :read_only do
    page.driver.browser.js_errors = false
    visit '/'
    home_page = Microfilms::Pages::HomePage.new
    expect(home_page).to be_on_page
  end

  scenario 'Test facet navigation', :read_only do
    page.driver.browser.js_errors = false
    visit '/'
    within('.facets') do
      click_on('City')
      expect(page).to have_link 'more »'
      click_on('more »')
    end
    expect(page).to have_selector('#ajax-modal', visible: true)
    within('#ajax-modal') do
      expect(page).to have_link 'A-Z Sort'
      expect(page).to have_no_link 'Numerical Sort'
      click_on('A-Z Sort')
      expect(page).to have_no_link 'A-Z Sort'
      expect(page).to have_link 'Numerical Sort'
    end
  end
end
