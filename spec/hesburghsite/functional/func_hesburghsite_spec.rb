# frozen_string_literal: true
require 'hesburghsite/hesburghsite_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Test 1: Loads Homepage', :read_only do
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

  scenario 'Test 2: Visit Story Index', :read_only do
    page.driver.browser.js_errors = false # JS erors on some of the pages
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
      expect(page).to have_css('h2 a', count: 5) #should be 10 but not all header links made yet
      expect(page).to have_css('a img', count: 10)
      expect(page).to have_css('li a', count: 25) #should be 57 but not all list links made yet
    end
  end

  scenario 'Test 3: Click on chapter on Story Index page', :read_only do
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
  scenario 'Test 4: Click specific story on Story Index page', :read_only do
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
  scenario 'Test 5: Visit the Media Gallery page', :read_only do
    page.driver.browser.js_errors = false
    visit '/'
    click_on('Media Gallery')
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
    within('article.media') do
      expect(page).to have_css('video', count: 3)
      expect(page).to have_css('audio')
    end
  end
  scenario 'Test 6: Click on Speeches link', :read_only do
    visit '/'
    new_window = window_opened_by {click_on('Speeches')}
    within_window new_window do
      expect(current_url).to eq('http://archives.nd.edu/Hesburgh/speeches.htm')
    end
  end
  scenario 'Test 7: Visit the Further Research page', :read_only do
    visit '/'
    new_window = window_opened_by {click_on('Further Research')}
    within_window new_window do
      within_window new_window do
        expect(current_url).to eq('http://archives.nd.edu/Hesburgh/index.htm')
      end
    end
  end
  scenario 'Test 8: Visit the About page', :read_only do
    page.driver.browser.js_errors = false
    visit '/'
    click_on('About')
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
    expect(page).to have_content('About Father Hesburgh')
    expect(page).to have_content('Leilani Briel')
  end
  scenario 'Test 9: Click on Keep in Touch tab', :read_only do
    visit '/'
    click_on('Keep in Touch')
    expect(page).to have_selector('#mailinglist', visible: true)
    within('#mc_embed_signup_scroll') do
      expect(page).to have_css('label', count: 3)
      expect(page).to have_css('input', id: 'mce-EMAIL')
      expect(page).to have_css('input', id: 'mce-FNAME')
      expect(page).to have_css('input', id: 'mce-LNAME')
      expect(page).to have_selector('.button', visible: true)
    end
  end
end
