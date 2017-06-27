# frozen_string_literal: true
require 'webRenovation/webRenovation_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Load Homepage', :read_only, :smoke_test do
    page.driver.browser.js_errors = false
    visit '/'
    home_page = WebRenovation::Pages::HomePage.new
    expect(home_page).to be_on_page
  end

  scenario 'Find A-Z databases', :read_only, :smoke_test do
    page.driver.browser.js_errors = false
    visit '/'
    click_on('Research', exact: true)
    click_on('Browse A-Z Databases')
    expect(page).to have_selector(".alphabet")
    expect(page).to have_css('h2', text:'Databases: A')
  end

  scenario 'Go to Reserve a Room Page', :read_only, :smoke_test do
    page.driver.browser.js_errors = false
    visit '/'
    within('.row.services') do
      find_link(title: 'Reserve a Room').trigger('click')
    end
    last_opened_window = page.driver.browser.window_handles.last
    page.driver.browser.switch_to_window(last_opened_window)
    expect(page.current_url).to eq('http://nd.libcal.com/#s-lc-box-2749-container-tab1')
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
