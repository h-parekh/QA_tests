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

  scenario 'Test 3: Click on chapter on Story Index page' do
    page.driver.browser.js_errors = false
    visit '/'
    click_on('Story Index')
    click_on('The Early Years')
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
    within('.large-12.columns') do
      expect(page).to have_css('img')
      expect(page).to have_css('p')
    end
    within('.large-6.columns.featured') do
      expect(page).to have_css('h1')
      expect(page).to have_css('h2 a')
    end
    within('.large-4.large-offset-2.columns') do
        ['Photo Gallery', 'Document Gallery'].shuffle.each do |name|
            expect(page).to have_link(name)
        end
    end
  end
  scenario 'Test 4: Click specific story on Story Index page' do
    page.driver.browser.js_errors = false
    visit '/'
    click_on('Story Index')
    click_on('Birth and Family')
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
    within('.large-12.columns') do
      expect(page).to have_css('img')
      expect(page).to have_css('p')
    end
    within('.gallery') do
      expect(page).to have_link('Hesburgh Oral History')
      expect(page).to have_link('Photo Gallery')
      expect(page).to have_link('Document Gallery')
    end
  end
end
