# frozen_string_literal: true
require 'microfilms/microfilms_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Loads Home Page' do
    page.driver.browser.js_errors = false
    visit '/'
    expect(page).to have_content 'About Searching'
    within('.search') do
      expect(page).to have_field 'q', type: 'text'
      expect(page).to have_button 'search'
    end
    within('.facets') do
      expect(page).to have_link 'Format'
      expect(page).to have_link 'Library'
      expect(page).to have_link 'City'
      expect(page).to have_link 'Country of Origin'
      expect(page).to have_link 'Collection'
      expect(page).to have_link 'Language'
      expect(page).to have_link 'Date Range'
      expect(page).to have_link 'Illuminations'
      expect(page).to have_link 'Musical Notation'
      expect(page).to have_link 'Commentary Volume'
      expect(page).to have_link 'Type of Text'
    end
  end

  scenario 'See List of Cities in A-Z Order' do
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
