# frozen_string_literal: true
require 'webRenovation/webRenovation_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Load Homepage', :read_only, :smoke_test do
    page.driver.browser.js_errors = false
    visit '/'
    home_page = WebRenovation::Pages::HomePage.new
    expect(home_page).to be_on_page
  end
end

feature 'Logged In User Browsing', js: true do
  let(:login) { WebRenovation::Utilities::Login.new(current_logger) }

  scenario 'Log In' do
    page.driver.browser.js_errors = false
    login.completeLogin
    homepage = WebRenovation::Pages::HomePage.new(login.username)
    expect(homepage).to be_on_page
  end
end