# frozen_string_literal: true
require 'microfilms/microfilms_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Test 1: Loads Home Page' do
    visit '/'
    puts current_url

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
end
