# frozen_string_literal: true
require 'webRenovation/webRenovation_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Load Homepage', :read_only, :smoke_test do
    visit '/'
    home_page = WebRenovation::Pages::HomePage.new
    expect(home_page).to be_on_page
  end

  scenario 'Find A-Z Databases', :read_only, :smoke_test do
    page.driver.browser.js_errors = false
    visit '/'
    within('.uNavigation') do
      find_by_id('research').trigger('click')
      click_on('Browse A-Z Databases')
    end
    room_reservation = WebRenovation::Pages::AZDatabases.new
  end

  scenario 'Reserve a Room underneath Services Tab', :read_only, :smoke_test do
    page.driver.browser.js_errors = false
    visit '/'
    within('.uNavigation') do
      find_by_id('services').trigger('click')
      click_on('Reserve a Room')
    end
    room_reservation_services_tab = WebRenovation::Pages::RoomReservationServicesTabPage.new
    expect(room_reservation_services_tab).to be_on_page
  end

  scenario 'Reserve a Room Button', :read_only, :smoke_test do
    page.driver.browser.js_errors = false
    visit '/'
    within('.services.hservices') do
      find_link(title: 'Reserve a Room').trigger('click')
    end
    room_reservation = WebRenovation::Pages::RoomReservationPage.new
    expect(room_reservation).to be_on_page
  end

  scenario 'Technology Lending Button', :read_only, :smoke_test do
    page.driver.browser.js_errors = false
    visit '/'
    within('.services.hservices') do
      find_link(title:'Technology Lending').trigger('click')
    end
    technology_lending = WebRenovation::Pages::TechnologyLendingPage.new
    expect(technology_lending).to be_on_page
  end

  scenario 'Go to Library Giving Page', :read_only, :smoke_test do
    visit '/'
    within('.row.bottom-xs') do
      click_on('Library Giving')
    end
    library_giving = WebRenovation::Pages::LibraryGivingPage.new
    expect(library_giving).to be_on_page
  end

  scenario 'Go to Library Jobs Page', :read_only, :smoke_test do
    visit '/'
    within('.row.bottom-xs') do
      click_on('Jobs')
    end
    library_jobs = WebRenovation::Pages::LibraryJobsPage.new
    expect(library_jobs).to be_on_page
  end

  scenario 'Load Pathfinder', :read_only, :smoke_test do
    visit '/architecture/'
    pathfinder = WebRenovation::Pages::PathfinderPage.new
    expect(pathfinder).to be_on_page
  end

  scenario 'Chat with Librarian via button' do
    visit '/'
    within('#chat.footer-chat') do
      find('.chat-button').click
      expect(page).to have_selector(".chat-open")
      expect(page).to have_css('iframe')
    end
  end

  scenario 'Go to Workshops page' do
    visit '/'
    find('#services').click
    find_link('Workshops', href: '/workshops').trigger('click')
    workshop = WebRenovation::Pages::WorkshopPage.new
    expect(workshop).to be_on_page
    click_on('Library Workshop Registration Portal')
    calendar = WebRenovation::Pages::CalendarPage.new
    expect(calendar).to be_on_page
  end

  scenario 'Go to Hours Page' do
    visit '/'
    find_link('Hours', href: '/hours').click
    hours = WebRenovation::Pages::HoursPage.new
    expect(hours).to be_on_page
  end

  scenario 'Search using OneSearch from HomePage' do
    visit '/'
    find('#header-search-button').click
    find_button('Search').trigger('click')
    search = WebRenovation::Pages::SearchPage.new
    # waits for search to load fully
    sleep(1)
    expect(search).to be_on_page
  end

  scenario 'Search using ND Catalog from HomePage' do
    visit '/'
    find('#header-search-button').click
    find('.current-search').click
    within('.uSearchOptionList') do
      find('p', text: 'ND Catalog').click
    end
    find_button('Search').trigger('click')
    search = WebRenovation::Pages::SearchPage.new
    # waits for search to load fully
    sleep(1)
    expect(search).to be_on_page
  end
end


feature 'Logged In User Browsing', js: true do
  let(:login) { LoginPage.new(current_logger) }
  scenario 'Log In and View Checked Out/Pending Items' do
    visit '/'
    click_on('Login')
    login.completeLogin
    accountpage = WebRenovation::Pages::AccountPage.new(loggedin: true)
    expect(accountpage).to be_on_page
  end

  scenario 'View Courses/Instructs' do
    visit '/'
    click_on('Login')
    login.completeLogin
    find_link('My Courses').click
    coursesPage = WebRenovation::Pages::CoursesPage.new(loggedin: true)
    expect(coursesPage).to be_on_page
  end
end
