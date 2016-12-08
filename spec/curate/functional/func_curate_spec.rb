# frozen_string_literal: true
require 'curate/curate_spec_helper'

log = Logging.logger['curate']
Logging.appenders.stdout(layout: Logging.layouts.pattern(format_as: :json))

log.add_appenders('stdout')
log.level = :info

feature 'User Browsing', js: true do
  require 'curate/pages/home_page'
  scenario 'Test start: Load Homepage' do
    log.info RSpec.current_example.description
    visit '/'
    log.info current_url
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_page
    log.info "Test complete: Load Homepage"
  end

  require 'curate/pages/about_page'
  scenario 'Test start: Go to About page' do
    log.info RSpec.current_example.description
    visit '/'
    click_on('About')
    log.info current_url
    about_page = Curate::Pages::AboutPage.new
    expect(about_page).to be_on_page
    log.info "Test complete: Go to About page"
  end

  require 'curate/pages/faq_page'
  scenario 'Test start: Go to FAQ page' do
    log.info RSpec.current_example.description
    visit '/'
    click_on('FAQ')
    log.info current_url
    faq_page = Curate::Pages::FaqPage.new
    expect(faq_page).to be_on_page
    log.info 'Test complete: Go to FAQ page'
  end

  require 'curate/pages/catalog_page'
  scenario 'Test 6a: Go to catalog search page with empty search term' do
    log.info RSpec.current_example.description
    visit '/'
    click_on('Search')
    log.info current_url
    catalog_page = Curate::Pages::CatalogPage.new({})
    expect(catalog_page).to be_on_page
    print "Clicked empty search\n"
  end

  scenario 'Test 6b: Go to catalog search page with term "Article"' do
    visit '/'
    search_term = "Article"
    fill_in('catalog_search', with: search_term)
    click_on('Search')
    log.info current_url
    catalog_page = Curate::Pages::CatalogPage.new(search_term: search_term)
    expect(catalog_page).to be_on_page
    print "Clicked search for #{search_term}\n"
    click_on('Clear all')
    expect(catalog_page).to be_on_base_url
    print "Clicked on clear all\n"
  end

  scenario 'Test 6c: Category search for Theses' do
    log.info RSpec.current_example.description
    visit '/'
    title = 'Theses & Dissertations'
    click_on(title)
    log.info current_url
    category_page = Curate::Pages::CatalogPage.new(category: :thesis)
    expect(category_page).to be_on_page
    print "Clicked '#{title}' Link\n"
    click_on('Clear all')
    expect(category_page).to be_on_base_url
    print "Clicked on clear all\n"
  end

  scenario 'Test 6d: Category search for Articles' do
    log.info RSpec.current_example.description
    visit '/'
    title = 'Articles & Publications'
    click_on(title)
    log.info current_url
    category_page = Curate::Pages::CatalogPage.new(category: :article)
    expect(category_page).to be_on_page
    print "Clicked '#{title}' Link\n"
    click_on('Clear all')
    expect(category_page).to be_on_base_url
    print "Clicked on clear all\n"
  end

  scenario 'Test 6e: Category search for Datasets' do
    log.info RSpec.current_example.description
    visit '/'
    title = 'Datasets & Related Materials'
    click_on(title)
    log.info current_url
    category_page = Curate::Pages::CatalogPage.new(category: :dataset)
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

  require 'curate/pages/departments_page'
  scenario 'Test 8: Materials by Department link' do
    log.info RSpec.current_example.description
    visit '/'
    click_on('Materials by Department')
    log.info current_url
    dept_page = Curate::Pages::DepartmentsPage.new
    expect(dept_page).to be_on_page
    print "Clicked 'Materials by Department' Link\n"
    departmental_link = dept_page.select_random_departmental_link
    dept_search_page = Curate::Pages::CatalogPage.new(category: :department, departmental_link: departmental_link)
    visit departmental_link.link
    log.info current_url
    expect(dept_search_page).to be_on_page
    print "Clicked department search for #{departmental_link.caption}\n"
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

feature 'Facet Navigation', js: true do
  scenario 'Department or Unit' do
    visit '/'
    click_on('Search')
    print "Testing #{current_url}\n"
    expect(page).not_to have_selector("#ajax-modal")
    click_on('Department or Unit')
    expect(page).to have_selector('#ajax-modal', visible: true)
    expect(page).to have_content('Department or Unit')
    print "Clicked  Department or Unit \n"
    within('#ajax-modal') do
      find('.close').click
    end
    expect(page).not_to have_selector("#ajax-modal")
  end

  scenario 'Collection' do
    visit '/'
    click_on('Search')
    print "Testing #{current_url}\n"
    expect(page).not_to have_selector("#ajax-modal")
    click_on('Collection')
    expect(page).to have_selector('#ajax-modal', visible: true)
    expect(page).to have_content('Collection')
    print "Clicked  Department or Unit \n"
    within('#ajax-modal') do
      find('.close').click
    end
    expect(page).not_to have_selector("#ajax-modal")
  end

  scenario 'Type of Work' do
    visit '/'
    click_on('Search')
    expect(page).not_to have_css('#collapse_Type_of_Work.in.collapse')
    find("a[data-target='#collapse_Type_of_Work']").click
    expect(page).to have_css('#collapse_Type_of_Work.in.collapse')
  end

  scenario 'Type of Work' do
    visit '/'
    click_on('Search')
    expect(page).not_to have_css('#collapse_Type_of_Work.in.collapse')
    find("a[data-target='#collapse_Type_of_Work']").click
    expect(page).to have_css('#collapse_Type_of_Work.in.collapse')
  end

  scenario 'Creator' do
    visit '/'
    click_on('Search')
    expect(page).not_to have_css('#collapse_Creator.in.collapse')
    find("a[data-target='#collapse_Creator']").click
    expect(page).to have_css('#collapse_Creator.in.collapse')
  end

  scenario 'Subject' do
    visit '/'
    click_on('Search')
    expect(page).not_to have_css('#collapse_Subject.in.collapse')
    find("a[data-target='#collapse_Subject']").click
    expect(page).to have_css('#collapse_Subject.in.collapse')
  end

  scenario 'Language' do
    visit '/'
    click_on('Search')
    expect(page).not_to have_css('#collapse_Language.in.collapse')
    find("a[data-target='#collapse_Language']").click
    expect(page).to have_css('#collapse_Language.in.collapse')
  end

  scenario 'Publisher' do
    visit '/'
    click_on('Search')
    expect(page).not_to have_css('#collapse_Publisher.in.collapse')
    find("a[data-target='#collapse_Publisher']").click
    expect(page).to have_css('#collapse_Publisher.in.collapse')
  end

  scenario 'Academic Status' do
    visit '/'
    click_on('Search')
    expect(page).not_to have_css('#collapse_Academic_Status.in.collapse')
    find("a[data-target='#collapse_Academic_Status']").click
    expect(page).to have_css('#collapse_Academic_Status.in.collapse')
  end
end
