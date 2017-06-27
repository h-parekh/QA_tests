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
    visit '/architecture/'
    pathfinder = WebRenovation::Pages::PathfinderPage.new
    expect(pathfinder).to be_on_page
  end

  scenario 'Chat with Librarian via button' do
    page.driver.browser.js_errors = false
    visit '/'
    within('#chat.footer-chat') do
      find('.chat-button').click
      expect(page).to have_selector(".chat-open")
      expect(page).to have_css('iframe')
    end
  end
end

feature 'Logged In User Browsing', js: true do
  let(:login) { LoginPage.new(current_logger) }
  scenario 'Log In and View Checked Out/Pending Items' do
    page.driver.browser.js_errors = false
    visit '/'
    find('.log-in-out').click
    login.completeLogin
    accountpage = WebRenovation::Pages::AccountPage.new(loggedin: true)
    expect(accountpage).to be_on_page
  end

  scenario 'View Courses/Instructs' do
    page.driver.browser.js_errors = false
    visit '/'
    find('.log-in-out').click
    login.completeLogin
    accountPage = WebRenovation::Pages::AccountPage.new(loggedin: true)
    expect(accountPage).to be_on_page
    find_link('My Courses').click
    coursesPage = WebRenovation::Pages::CoursesPage.new(loggedin: true)
    expect(coursesPage).to be_on_page
  end
end
