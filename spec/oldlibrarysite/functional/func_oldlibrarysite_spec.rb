# frozen_string_literal: true
require 'oldlibrarysite/oldlibrarysite_spec_helper'

feature 'Institutional Login', js: true do
  let(:login_page) { LoginPage.new(current_logger, account_details_updated: false) }
  scenario 'Sign in by institution (Notre Dame)' do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    within('.dropdown') do
      find("input[value='Log Out']")
    end
  end
end
