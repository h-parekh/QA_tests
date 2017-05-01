# frozen_string_literal: true
require 'webRenovation/webRenovation_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Load Homepage', :read_only, :smoke_test do
    page.driver.browser.js_errors = false
    visit '/'
    home_page = WebRenovation::Pages::HomePage.new
    expect(home_page).to be_on_page
  end


  scenario 'Load Pathfinder', :read_only, :smoke_test do
    page.driver.browser.js_errors = false
    visit '/pathfinder/architecture/'
    pathfinder = WebRenovation::Pages::PathfinderPage.new
    expect(pathfinder).to be_on_page
  end
end

feature 'Logged In User Browsing', js: true do
  let(:login) { WebRenovation::Utilities::Login.new(current_logger) }

  scenario 'Log In' do
    page.driver.browser.js_errors = false
    visit '/'
    login.completeLogin
    homepage = WebRenovation::Pages::HomePage.new
    expect(homepage).to be_on_page
  end

  scenario 'View Checked Out Items' do
    page.driver.browser.js_errors = false
    visit '/'
    login.completeLogin
    homepage = WebRenovation::Pages::HomePage.new
    find('.login').click
    accountPage = WebRenovation::Pages::AccountPage.new
    expect(accountPage).to be_on_page
  end

  scenario 'View Courses' do
    page.driver.browser.js_errors = false
    visit '/'
    login.completeLogin
    homepage = WebRenovation::Pages::HomePage.new
    find('.login').click
    find_button('My Courses').click
    coursesPage = WebRenovation::Pages::CoursesPage.new
    expect(coursesPage).to be_on_page
  end
end