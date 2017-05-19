# frozen_string_literal: true
require 'hesburghsite/hesburghsite_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Test 1: Loads Homepage' do
    visit '/'
    within('.signup') do
      expect(page).to have_link('Keep in Touch')
    end
    within('.top-bar') do
      expect(page).to have_link('Home')
      expect(page).to have_link('Story Index')
      expect(page).to have_link('Media Gallery')
      expect(page).to have_link('Speeches')
      expect(page).to have_link('Further Research')
      expect(page).to have_link('About')
    end
    expect(page).to have_selector('.flipster.flipster-active.flipster-carousel')
    expect(page).to have_selector('#timeline')
  end
end
