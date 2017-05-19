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

  scenario 'Test 2: Visit Story Index' do
    page.driver.browser.js_errors = false
    visit '/'
    click_on('Story Index')
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
    within('.large-12.columns.contents') do
      expect(page).to have_css('h2 a', count: 10)
      expect(page).to have_css('a img', count: 10)
      expect(page).to have_css('li a', count: 57)
    end
  end
end
