# frozen_string_literal: true

require 'primo/primo_spec_helper'

feature 'User browsing', js: true do
  scenario 'Load homepage', :smoke_test, :read_only do
    visit '/'
    home_page = Primo::Pages::HomePage.new
    expect(home_page).to be_on_page
  end

  scenario 'User searches OneSearch', :read_only do
    visit '/'
    home_page = Primo::Pages::HomePage.new
    expect(home_page).to be_on_page
    search_term = 'Automated Testing'
    fill_in('searchBar', with: search_term)
    # Clicks first item from auto suggest (OneSearch)
    find('#prm-simple-search').find_all('li')[0].click
    search_results_page = Primo::Pages::SearchResultsPage.new
    expect(search_results_page).to be_on_page
  end

  scenario 'User searches NDCatalog', :read_only do
    visit '/'
    home_page = Primo::Pages::HomePage.new
    expect(home_page).to be_on_page
    search_term = 'Automated Testing'
    fill_in('searchBar', with: search_term)
    # Clicks first item from auto suggest (ND Catalog)
    find('#prm-simple-search').find_all('li')[1].click
    search_results_page = Primo::Pages::SearchResultsPage.new
    expect(search_results_page).to be_on_page
  end
end
