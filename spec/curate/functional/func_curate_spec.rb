# frozen_string_literal: true
require 'curate/curate_spec_helper'
require 'csv'
class Login
  include Capybara::DSL
  include CapybaraErrorIntel::DSL
  attr_reader :userName
  attr_reader :passWord
  attr_reader :passCode

  def initialize
    userNumber = Random.rand(1..5)
    current_user = 0
    CSV.foreach("/Volumes/Infrastructure-2/vars/QA/TestCredentials.csv") do |row|
      if current_user == userNumber
        @userName = row[0]
        @passWord = row[1]
        @passCode = row[2]
      end
      current_user = current_user+1
    end
  end

  def completeLogin
    visit '/'
    click_on('Log In')
    fill_in('username', with: userName)
    fill_in('password', with: passWord)

    #click_on('submit')
    find('[name=submit]').click
    sleep(3)
    fill_in('passcode', with: passCode)
    find('[name=submit]').click
    sleep(3)
  end
end

feature 'User Browsing', js: true do
  #let(:user) {Login.new}
  scenario 'Load Homepage' do
    user = Login.new
    puts user.userName
    visit '/'
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_page
  end

  scenario 'Go to About page' do
    visit '/'
    click_on('About')
    about_page = Curate::Pages::AboutPage.new
    expect(about_page).to be_on_page
  end

  scenario 'Go to FAQ page' do
    visit '/'
    click_on('FAQ')
    faq_page = Curate::Pages::FaqPage.new
    expect(faq_page).to be_on_page
  end

  scenario 'Go to catalog search page with empty search term' do
    visit '/'
    click_on('Search')
    catalog_page = Curate::Pages::CatalogPage.new({})
    expect(catalog_page).to be_on_page
  end

  scenario 'Go to catalog search page with term "Article"' do
    visit '/'
    search_term = "Article"
    fill_in('catalog_search', with: search_term)
    click_on('Search')
    catalog_page = Curate::Pages::CatalogPage.new(search_term: search_term)
    expect(catalog_page).to be_on_page
    click_on('Clear all')
    expect(catalog_page).to be_on_base_url
  end

  scenario 'Category search for Theses' do
    visit '/'
    title = 'Theses & Dissertations'
    click_on(title)
    category_page = Curate::Pages::CatalogPage.new(category: :thesis)
    expect(category_page).to be_on_page
    click_on('Clear all')
    expect(category_page).to be_on_base_url
  end

  scenario 'Category search for Articles' do
    visit '/'
    title = 'Articles & Publications'
    click_on(title)
    category_page = Curate::Pages::CatalogPage.new(category: :article)
    expect(category_page).to be_on_page
    click_on('Clear all')
    expect(category_page).to be_on_base_url
  end

  scenario 'Category search for Datasets' do
    visit '/'
    title = 'Datasets & Related Materials'
    click_on(title)
    category_page = Curate::Pages::CatalogPage.new(category: :dataset)
    expect(category_page).to be_on_page
    click_on('Clear all')
    expect(category_page).to be_on_base_url
  end

  scenario 'Contribute Your Work' do
    visit '/'
    click_on('Contribute Your Work')
    contribute_page = Curate::Pages::ContributePage.new
    expect(contribute_page).to be_on_page
  end

  scenario 'Materials by Department link' do
    visit '/'
    click_on('Materials by Department')
    dept_page = Curate::Pages::DepartmentsPage.new
    expect(dept_page).to be_on_page
    departmental_link = dept_page.select_random_departmental_link
    dept_search_page = Curate::Pages::CatalogPage.new(category: :department, departmental_link: departmental_link)
    visit departmental_link.link
    expect(dept_search_page).to be_on_page
  end
end

feature 'Requesting Help', js: true do
  scenario 'Go to help page' do
    visit '/'
    click_on('Help')
    help_page = Curate::Pages::ModalHelpPage.new
    expect(help_page).to be_on_page
    fill_in('help_request_name', with: 'some name')
    click_on('Submit')
    expect(page).to have_selector('#ajax-modal', visible: true)
  end
end

feature 'Facet Navigation', js: true do
  scenario "modal facets" do
    visit '/'
    click_on('Search')
    ['Department or Unit', 'Collection'].shuffle.each do |facet_name|
      current_logger.info(context: "Processing Facet: #{facet_name}")
      expect(page).not_to have_selector("#ajax-modal")
      click_on(facet_name)
      expect(page).to have_selector('#ajax-modal', visible: true)
      expect(page).to have_content(facet_name)
      within('#ajax-modal') do
        find('.close').click
      end
      expect(page).not_to have_selector("#ajax-modal", visible: true)
    end
  end

  scenario 'non-modal Facets' do
    visit '/'
    click_on('Search')
    ['Type_of_Work', 'Creator', 'Subject', 'Language', 'Publisher', 'Academic_Status'].shuffle.each do |facet_name|
      sleep(0.3) # Included because the JS expand behavior was not always completing before the driver said it was ready
      current_logger.info(context: "Processing Facet: #{facet_name}")
      expect(page).not_to have_css("ul.facets #collapse_#{facet_name}.in")
      find("ul.facets a[data-target=\"#collapse_#{facet_name}\"]").click
      expect(page).to have_css("ul.facets #collapse_#{facet_name}.in .slide-list")
    end
  end
end
feature 'Logged In User Browsing', js: true do
  let(:user) {Login.new}
  scenario "Log in" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
  end
  scenario "Manage My Works" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.my-actions").click
    checkMyWorksDropdown()
    click_on("My Works")
    sleep(3)
    within('div.applied-constraints') do
      expect(page).to have_content("Work")
    end
    expect(find("#works_mine")).to be_checked
  end
  scenario "Manage My Groups" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.my-actions").click
    checkMyWorksDropdown()
    click_on("My Groups")
    sleep(3)
    expect(page).to have_content("My Groups")
    expect(page).to have_selector(:link_or_button, "Create Group")
  end
  scenario "Manage My Collections" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.my-actions").click
    checkMyWorksDropdown()
    click_on("My Collections")
    sleep(3)
    within('div.applied-constraints') do
      expect(page).to have_content("Work")
    end
    expect(find("#works_mine")).to be_checked
  end
  scenario "Manage My Profile" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.my-actions").click
    checkMyWorksDropdown()
    click_on("My Profile")
    sleep(3)
    expect(page).to have_selector(:link_or_button, "Add a Section to my Profile")
    expect(page).to have_selector(:link_or_button, "Update Personal Information")
  end
  scenario "Manage My Delegates" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.my-actions").click
    checkMyWorksDropdown()
    click_on("My Delegates")
    sleep(3)
    expect(page).to have_content("Manage Your Delegates")
    expect(page).to have_content("Grant Delegate Access")
    expect(page).to have_content("Authorized Delegates")
    #within('div.proxy-rights.row.with-headroom') do
      #find('#user')
    #end
  end
  scenario "Deposit New Article" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.add-content").click
    checkDepositDropdown()
    click_on("New Article")
    sleep(3)
    expect(page).to have_content("Describe Your Article")
    findInputFields()
  end
  scenario "Deposit New Dataset" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.add-content").click
    checkDepositDropdown()
    click_on("New Dataset")
    sleep(3)
    expect(page).to have_content("Describe Your Dataset")
    findInputFields(item: "dataset")
  end
  scenario "Deposit New Document" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.add-content").click
    checkDepositDropdown()
    click_on("New Document")
    sleep(3)
    expect(page).to have_content("Describe Your Document")
    findInputFields(item: "document")
    expect(page).to have_field("document[type]")
  end

  scenario "Deposit New Image" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.add-content").click
    checkDepositDropdown()
    click_on("New Image")
    sleep(3)
    expect(page).to have_content("Describe Your Image")
    expect(page).to have_field("image[title]")
    expect(page).to have_field("image[rights]")
    expect(page).to have_field("image[date_created]")
    expect(page).to have_css("div.control-group.text.optional.image_description")
  end

  scenario "Visit More Options" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.add-content").click
    checkDepositDropdown()
    click_on("More Options")
    sleep(3)
    options_page = Curate::Pages::OptionsPage.new
    expect(options_page).to be_on_page
  end

  scenario "Deposit New Audio" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.add-content").click
    checkDepositDropdown()
    click_on("More Options")
    sleep(3)
    options_page = Curate::Pages::OptionsPage.new
    expect(options_page).to be_on_page
    find('.add-button.btn.btn-primary.add_new_audio').click
    sleep(2)
    expect(page).to have_content("Describe Your Audio")
    findInputFields(item: 'audio')
    expect(page).to have_css("div.control-group.text.optional.audio_description")
  end
end

def checkMyWorksDropdown
  find("div.btn-group.my-actions.open")
  expect(page).to have_content("My Works")
  expect(page).to have_content("My Collections")
  expect(page).to have_content("My Groups")
  expect(page).to have_content("My Profile")
  expect(page).to have_content("My Delegates")
  expect(page).to have_content("Log Out")
end

def checkDepositDropdown
  find("div.btn-group.add-content.open")
  expect(page).to have_content("New Article")
  expect(page).to have_content("New Dataset")
  expect(page).to have_content("New Document")
  expect(page).to have_content("New Image")
  expect(page).to have_content("More Options")
end

def findInputFields(item: 'article')
  expect(page).to have_field("#{item}[title]")
  if item == 'dataset'
    expect(page).to have_css("div.control-group.text.required.#{item}_description")
  elsif item == 'document' || item == 'audio' # don't look for abstract with documents
  else
    expect(page).to have_css("div.control-group.text.required.#{item}_abstract")
  end
  expect(page).to have_field("#{item}[rights]")
end
