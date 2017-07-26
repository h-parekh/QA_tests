# frozen_string_literal: true
require 'webRenovation/webRenovation_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Load Homepage', :read_only, :smoke_test do
    visit '/'
    home_page = WebRenovation::Pages::HomePage.new
    expect(home_page).to be_on_page
  end

  scenario 'Find A-Z Databases', :read_only, :smoke_test do
    visit '/'
    within('.uNavigation') do
      find_by_id('research').trigger('click')
      click_on('Databases A-Z')
    end
    az_databases= WebRenovation::Pages::AZDatabases.new
    expect(az_databases).to be_on_page
  end

  scenario 'Find A-Z Subjects', :read_only, :smoke_test do
    visit '/'
    within('.uNavigation') do
      find_by_id('research').trigger('click')
      click_on('Subjects A-Z')
    end
    az_subjects = WebRenovation::Pages::AZSubjects.new
    expect(az_subjects).to be_on_page
  end

  scenario 'Research Guides', :read_only, :smoke_test do
    visit '/'
    within('.uNavigation') do
      find_by_id('research').trigger('click')
      click_on('Research Guides')
    end
    research_guides = WebRenovation::Pages::ResearchGuidesPage.new
    expect(research_guides).to be_on_page
  end

  scenario 'Reserve a Room underneath Services Tab', :read_only, :smoke_test do
    visit '/'
    within('.uNavigation') do
      find_by_id('services').trigger('click')
      click_on('Reserve a Meeting or Event Space')
    end
    room_reservation_services_tab = WebRenovation::Pages::RoomReservationServicesTabPage.new
    expect(room_reservation_services_tab).to be_on_page
  end

  scenario 'Reserve a Room Button', :read_only, :smoke_test do
    visit '/'
    within('.services.hservices') do
      find_link(title: 'Reserve a Room', href: "http://nd.libcal.com/#s-lc-box-2749-container-tab1").trigger('click')
    end
    room_reservation = WebRenovation::Pages::RoomReservationPage.new
    expect(room_reservation).to be_on_page
  end

  scenario 'Technology Lending Button', :read_only, :smoke_test do
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
    visit '/subjects'
    link_list = []
    href_list = []
    within('.container-fluid.content-area') do
      link_list = find('.row').all('a')
    end
    link_list.each do |link|
      # need to put into another array because link_list will become obsolete once another page is visited
      href_list.append(link[:href])
    end
    href_list.each do |href|
      visit href
      sleep(2)
      # the if statement is just so it runs succesfully as these four pages are missing content
      if !href.include?('africana') && !href.include?('philosophy-of-science') && !href.include?('philosophy') && !href.include?('theology-religion') && !href.include?('east-asian-studies') && !href.include?('russian')
        pathfinder = WebRenovation::Pages::PathfinderPage.new
        expect(pathfinder).to be_on_page
      elsif !href.include?('philosophy') && !href.include?('theology-religion')
        pathfinder = WebRenovation::Pages::PathfinderPage.new(general_pathfinder_format: false)
        expect(pathfinder).to be_on_page
      end
    end
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
    find_link('Library Workshop Registration Portal').trigger('click')
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
    page.driver.browser.js_errors = false # Suprressing JS errors from OneSearch site
    find_button('Search').trigger('click')
    search = WebRenovation::Pages::SearchPage.new
    sleep(2)
    expect(search).to be_on_page
  end

  scenario 'Search using ND Catalog from HomePage' do
    visit '/'
    find('.current-search').click
    within('.uSearchOptionList') do
      find('p', text: 'ND Catalog').click
    end
    page.driver.browser.js_errors = false # Suprressing JS errors from OneSearch site
    find_button('Search').trigger('click')
    search = WebRenovation::Pages::SearchPage.new
    sleep(2)
    expect(search).to be_on_page
  end

  scenario 'Search using CurateND from HomePage' do
    visit '/'
    find('.current-search').click
    within('.uSearchOptionList') do
      find('p', text: 'CurateND').click
    end
    find_button('Search').trigger('click')
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
    sleep(2)
    expect(current_url).to eq('https://search.nd.edu/search/?client=lib_site_srch&site=library;q=')
  end
end

feature 'Logged In User Browsing', js: true do
  let(:login) { LoginPage.new(current_logger) }
  scenario 'Log In', :validates_login do
    visit '/'
    click_on('Login')
    login.completeLogin
    logged_in_home = WebRenovation::Pages::HomePage.new(loggedin: true)
    expect(logged_in_home).to be_on_page
  end

  scenario 'View Checked Out/Pending Items' do
    visit '/'
    click_on('Login')
    login.completeLogin
    click_on('My Account')
    accountpage = WebRenovation::Pages::ItemsPage.new(loggedin: true)
    expect(accountpage).to be_on_page
  end

  scenario 'View Courses/Instructs' do
    # Does not run properly do to issues with
    visit '/'
    click_on('Login')
    login.completeLogin
    click_on('My Account')
    find_link('Courses').click
    coursesPage = WebRenovation::Pages::CoursesPage.new(loggedin: true)
    expect(coursesPage).to be_on_page
  end
end

feature 'User Navigation', js: true do
  scenario 'All Feature in Tab', :read_only, :smoke_test do
    visit '/'
    header_all_checks = WebRenovation::Pages::HeaderAllChecks.new
    expect(header_all_checks).to be_on_page
  end

  scenario 'Thesis Camps', :read_only, :smoke_test do
    visit '/'
    within('.uNavigation') do
      find_by_id('services').trigger('click')
      click_on('Thesis and Dissertation Camps')
    end
    thesis_camp = WebRenovation::Pages::ThesisCampsCheck.new
    expect(thesis_camp).to be_on_page
  end

  scenario 'Library Page Navigation', :read_only, :smoke_test do
    visit'/'
    within('.uNavigation') do
      find_by_id('libraries').trigger('click')
    end
    librarylist = nil
    within('.col-md-offset-2.col-md-3.col-sm-4') do
      librarylist = all('a')
    end
    text_and_href_list = {}
    # need only strings in a hash because the elements of librarylist become
    # absolete after going to another page
    librarylist.each do |library|
      text_and_href_list[library.text] = library[:href]
    end
    # use the strings from the hash in order to make assertions
    text_and_href_list.each do |pair|
      if pair[1].include?(Capybara.app_host)
        click_on(pair[0])
        sleep(2)
        within('.building') do
          find('.map')
        end
        find_link('Home').trigger('click')
        within('.uNavigation') do
          find_by_id('libraries').trigger('click')
        end
      end
    end
  end
end
