# frozen_string_literal: true
require 'oldlibrarysite/oldlibrarysite_spec_helper'

feature 'Institutional Login', js: true do
  let(:login_page) { LoginPage.new(current_logger, account_details_updated: false) }
  scenario 'Sign in by institution (Notre Dame)', :validates_login do
    page.driver.browser.js_errors = false # JS erors on some of the pages
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    within('.dropdown') do
      find("input[value='Log Out']")
    end
  end
end
