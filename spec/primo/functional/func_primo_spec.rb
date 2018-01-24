# frozen_string_literal: true

require 'primo/primo_spec_helper'

feature 'User browsing', js: true do
  scenario 'Load homepage', :smoke_test do
    page.driver.browser.js_errors = false
    visit '/'
    home_page = Primo::Pages::HomePage.new
    expect(home_page).to be_on_page
  end

  scenario 'User searches OneSearch' do
    page.driver.browser.js_errors = false
    visit '/'
    home_page = Primo::Pages::HomePage.new
    expect(home_page).to be_on_page
    expect(home_page).to be_onesearch_tab_activated
    search_term = 'Automated Testing'
    fill_in('search_field', with: search_term)
    find_button(id: 'goButton').trigger('click')
    search_results_page = Primo::Pages::SearchResultsPage.new
    expect(search_results_page).to be_on_page
  end

  scenario 'User searches NDCatalog' do
    page.driver.browser.js_errors = false
    visit '/'
    home_page = Primo::Pages::HomePage.new
    expect(home_page).to be_on_page
    # This selects the NDcatalog tab
    click_on('Search materials held by all Notre Dame campus libraries')
    expect(home_page).to be_ndcatalog_tab_activated
    search_term = 'Automated Testing'
    fill_in('search_field', with: search_term)
    find_button(id: 'goButton').trigger('click')
    search_results_page = Primo::Pages::SearchResultsPage.new
    expect(search_results_page).to be_on_page
  end
end
