# frozen_string_literal: true
require 'curate/curate_spec_helper'

Logging.logger.root.appenders = Logging.appenders.stdout
Logging.logger.root.level = :info

log = Logging.logger['curate']

feature 'User Browsing', js: true do
  #     scenario 'Test 1: Login to Curate with correct credentials' do
  #         visit '/'
  #         expect(page).to have_link 'Log In'
  #
  # #Using the same has_link assertion with options
  #         #expect(page).to have_link 'Log In', href: '/users/sign_in'
  #
  # #To print the html:
  #         #puts(page.html)
  #         #print page.html
  #
  # #Take screenshot of the page, save_and_open_screenshot needs launchy gem
  #         #page.save_screenshot('curate_test_screenshot.png')
  #         #page.save_and_open_screenshot('curate_test_screenshot2.png')
  #
  #         click_on('Log In')
  #         if expect(page).to have_field 'username', type: 'text'
  #           #getting username using highline gem syntax
  #           p_username = ask("Enter valid username:  ") { |q| q.echo = true }
  #           fill_in('username', with: p_username)
  #         else
  #           expect(page).to have_field 'password', type: 'password'
  #           print "Trusted device, needs only password\n"
  #         end
  #
  #         #getting password using highline gem syntax
  #         p_password = ask("Enter valid password:  ") { |q| q.echo = "*" }
  #         fill_in('password', with: p_password)
  #
  #         print "Logging in with username and password fields\n"
  #         puts current_url
  #         click_on('LOGIN')
  #
  # #Accessing a specific xpath and running a validation
  #         within('.mfa-text-wrapper') do
  #           expect(page).to have_content 'Send'
  #         end
  #
  #
  #         print("The next click should send a push to Android\n")
  #         expect(page).to have_button 'LOGIN'
  #
  #         puts current_url
  #         click_on('LOGIN')
  #         #Use below syntax if you want to wait
  #         #click_on('LOGIN', wait: 60)
  #
  #         # if expect(page).to have_content('Incorrect NetID or password.')
  #         #   print "Succesfull negative login test"
  #         # elsif expect(page).to have_content 'Android (2576)'
  #         #   page.save_screenshot('curate_test_screenshot.png')
  #         #   print "Succesfull postive login test"
  #         # end
  #     end
  #
  #     scenario 'Test 2: Login to Curate with incorrect credentials' do
  #                 visit '/'
  #                 expect(page).to have_link 'Log In'
  #                 click_on('Log In')
  #                 if expect(page).to have_field 'username', type: 'text'
  #                   #getting username using highline gem syntax
  #                   p_username = ask("Enter INVALID username:  ") { |q| q.echo = true }
  #                   fill_in('username', with: p_username)
  #                 else
  #                   expect(page).to have_field 'password', type: 'password'
  #                   print "Trusted device, needs only password\n"
  #                 end
  #
  #                 #getting password using highline gem syntax
  #                 p_password = ask("Enter INVALID password:  ") { |q| q.echo = "*" }
  #                 fill_in('password', with: p_password)
  #
  #                 print "Logging in with INVALID username and password fields\n"
  #
  #                 click_on('LOGIN')
  #                 if expect(page).to have_content 'Incorrect NetID or password.'
  #                   print "Successfully tested login with invalid creds\n"
  #                 end
  #     end

  require 'curate/pages/home_page'
  scenario 'Test 3: Test homepage' do
    visit '/'
    print "Testing #{current_url}\n"
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_page
    print "Accessed home page\n"
  end

  require 'curate/pages/about_page'
  scenario 'Test 4: Go to About page' do
    log.info RSpec.current_example.description
    visit '/'
    log.info current_url
    click_on('About')
    print "Testing #{current_url}\n"
    about_page = Curate::Pages::AboutPage.new
    expect(about_page).to be_on_page
    print "Clicked About\n"
  end

  require 'curate/pages/faq_page'
  scenario 'Test 5: Go to FAQ page' do
    visit '/'
    click_on('FAQ')
    print "Testing #{current_url}\n"
    faq_page = Curate::Pages::FaqPage.new
    expect(faq_page).to be_on_page
    print "Clicked FAQ\n"
  end

  require 'curate/pages/catalog_page'
  scenario 'Test 6a: Go to catalog search page with empty search term' do
    visit '/'
    click_on('Search')
    print "Testing #{current_url}\n"
    catalog_page = Curate::Pages::CatalogPage.new('')
    expect(catalog_page).to be_on_page
    print "Clicked empty search\n"
  end

  scenario 'Test 6b: Go to catalog search page with term "Article"' do
    visit '/'
    search_term = "Article"
    fill_in('catalog_search', with: search_term)
    click_on('Search')
    print "Testing #{current_url}\n"
    catalog_page = Curate::Pages::CatalogPage.new(search_term)
    expect(catalog_page).to be_on_page
    print "Clicked search for #{search_term}\n"
    click_on('Clear all')
    expect(catalog_page).to be_on_base_url
    print "Clicked on clear all\n"
  end

  require 'curate/pages/category_search_page'
  scenario 'Test 7a: Category search for Theses' do
    visit '/'
    title = 'Theses & Dissertations'
    click_on(title)
    print "Testing #{current_url}\n"
    category_page = Curate::Pages::CategorySearchPage.new(:thesis)
    expect(category_page).to be_on_page
    print "Clicked '#{title}' Link\n"
    click_on('Clear all')
    expect(category_page).to be_on_base_url
    print "Clicked on clear all\n"
  end

  scenario 'Test 7b: Category search for Articles' do
    visit '/'
    title = 'Articles & Publications'
    click_on(title)
    print "Testing #{current_url}\n"
    category_page = Curate::Pages::CategorySearchPage.new(:article)
    expect(category_page).to be_on_page
    print "Clicked '#{title}' Link\n"
    click_on('Clear all')
    expect(category_page).to be_on_base_url
    print "Clicked on clear all\n"
  end

  scenario 'Test 7c: Category search for Datasets' do
    visit '/'
    title = 'Datasets & Related Materials'
    click_on(title)
    print "Testing #{current_url}\n"
    category_page = Curate::Pages::CategorySearchPage.new(:dataset)
    expect(category_page).to be_on_page
    print "Clicked '#{title}' Link\n"
    click_on('Clear all')
    expect(category_page).to be_on_base_url
    print "Clicked on clear all\n"
  end

  require 'curate/pages/contribute_page'
  scenario 'Test 7: Contribute Your Work' do
    visit '/'
    click_on('Contribute Your Work')
    print "Testing #{current_url}\n"
    contribute_page = Curate::Pages::ContributePage.new
    expect(contribute_page).to be_on_page
    print "Clicked Contribute Your Work\n"
  end
end
feature 'Requesting Help', js: true do
  require 'curate/pages/modal_help_page'
  scenario 'Test 1: Go to help page' do
    visit '/'
    click_on('Help')
    print "Testing #{current_url}\n"
    help_page = Curate::Pages::ModalHelpPage.new
    expect(help_page).to be_on_page
    fill_in('help_request_name', with: 'some name')
    click_on('Submit')
    expect(page).to have_selector('#ajax-modal', visible: true)
  end
end
