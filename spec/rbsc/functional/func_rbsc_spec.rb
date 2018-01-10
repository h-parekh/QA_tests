# frozen_string_literal: true
require 'rbsc/rbsc_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Load homepage', :smoke_test do
    # Setting js_error false will suppress errors coming back from the site and let the tests finish
    page.driver.browser.js_errors = false
    visit '/'
    expect(page).to have_content 'Rare Books & Special Collections'
    expect(page).to have_content 'List of Finding Aids'
    within('#main-menu') do
      expect(page).to have_css 'li', count: 6
    end
  end
end
