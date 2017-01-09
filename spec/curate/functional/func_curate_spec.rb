# frozen_string_literal: true
require 'curate/curate_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Load Homepage' do
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
  scenario 'Department or Unit' do
    visit '/'
    click_on('Search')
    expect(page).not_to have_selector("#ajax-modal")
    click_on('Department or Unit')
    expect(page).to have_selector('#ajax-modal', visible: true)
    expect(page).to have_content('Department or Unit')
    within('#ajax-modal') do
      find('.close').click
    end
    expect(page).not_to have_selector("#ajax-modal")
  end

  scenario 'Collection' do
    visit '/'
    click_on('Search')
    expect(page).not_to have_selector("#ajax-modal")
    click_on('Collection')
    expect(page).to have_selector('#ajax-modal', visible: true)
    expect(page).to have_content('Collection')
    within('#ajax-modal') do
      find('.close').click
    end
    expect(page).not_to have_selector("#ajax-modal")
  end

  scenario 'Other facets' do
    visit '/'
    click_on('Search')
    facet_listing = ['Type_of_Work', 'Creator', 'Subject', 'Language', 'Publisher', 'Related_Resource(s)', 'Academic_Status'].freeze
    facet_listing.each do |facet_name|
      facet_title = facet_name.gsub('_',' ')
      current_logger.info(context: "Processing Facet: #{facet_name}")
      within('ul.facets') do
        current_logger.debug(context: "Facet #{facet_name} unavailable")unless has_content?(facet_title)
        expect(page).not_to have_css("#collapse_#{facet_name}.in")
        find("a[data-target=\"#collapse_#{facet_name}\"]").click
        expect(page).to have_css("#collapse_#{facet_name}.in")
      end
    end
  end
end
