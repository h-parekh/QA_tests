# frozen_string_literal: true
require 'webRenovation/webRenovation_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Load Homepage', :read_only, :smoke_test do
    visit '/'
    home_page = WebRenovation::Pages::HomePage.new
    expect(home_page).to be_on_page
  end

  scenario 'Find A-Z databases', :read_only, :smoke_test do
    visit '/'
    click_on('Research', exact: true)
    click_on('Browse A-Z Databases')
    expect(page).to have_selector(".alphabet")
    expect(page).to have_css('h2', text:'Databases: A')
  end

  scenario 'Go to Reserve a Room Page', :read_only, :smoke_test do
    visit '/'
    within('.row.services') do
      find_link(title: 'Reserve a Room').trigger('click')
    end
    last_opened_window = page.driver.browser.window_handles.last
    page.driver.browser.switch_to_window(last_opened_window)
    expect(page.current_url).to eq('http://nd.libcal.com/#s-lc-box-2749-container-tab1')
  end

  scenario 'Go to Library Giving Page', :read_only, :smoke_test do
    visit '/'
    within('.row.bottom-xs') do
      click_on('Library Giving')
    end
    last_opened_window = page.driver.browser.window_handles.last
    page.driver.browser.switch_to_window(last_opened_window)
    expect(page.current_url).to eq('http://librarygiving.nd.edu/')
  end

  scenario 'Go to Library Jobs Page', :read_only, :smoke_test do
    visit '/'
    within('.row.bottom-xs') do
      click_on('Jobs')
    end
    last_opened_window = page.driver.browser.window_handles.last
    page.driver.browser.switch_to_window(last_opened_window)
    expect(page.current_url).to eq('https://alpha.library.nd.edu/employment/')
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

  scenario 'Search using OneSearch from HomePage' do
    visit '/'
    find_button('Search').trigger('click')
    search = WebRenovation::Pages::SearchPage.new
    # waits for search to load fully
    sleep(1)
    expect(search).to be_on_page
  end

  scenario 'Search using ND Catalog from HomePage' do
    visit '/'
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

  scenario 'Search using CurateND from HomePage' do
    visit '/'
    find('.current-search').click
    within('.uSearchOptionList') do
      find('p', text: 'CurateND').click
    end
    find_button('Search').trigger('click')
    # waits for search to load fully
    sleep(2)
    expect(current_url).to eq('https://curate.nd.edu/catalog?utf8=%E2%9C%93&amp;search_field=all_fields&amp;q=')
  end

  scenario 'Search using Library Website from HomePage' do
    visit '/'
    find('.current-search').click
    within('.uSearchOptionList') do
      find('p', text: 'Library Website').click
    end
    find_button('Search').trigger('click')
    #waits for search to load fully
    sleep(1)
    expect(current_url).to eq('https://search.nd.edu/search/?client=lib_site_srch&amp;q=')
  end
end

feature 'Logged In User Browsing', js: true do
  let(:login) { LoginPage.new(current_logger) }
  scenario 'Log In and View Checked Out/Pending Items' do
    visit '/'
    find('.log-in-out').click
    login.completeLogin
    accountpage = WebRenovation::Pages::AccountPage.new
    expect(accountpage).to be_on_page
  end

  scenario 'View Courses/Instructs' do
    visit '/'
    find('.log-in-out').click
    login.completeLogin
    accountPage = WebRenovation::Pages::AccountPage.new
    expect(accountPage).to be_on_page
    find_link('My Courses').click
    coursesPage = WebRenovation::Pages::CoursesPage.new
    expect(coursesPage).to be_on_page
  end
end
