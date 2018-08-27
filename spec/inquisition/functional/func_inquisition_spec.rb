# frozen_string_literal: true

require 'inquisition/inquisition_spec_helper'

feature 'User Browsing', :read_only, js: true do
  scenario 'Load Homepage', :read_only, :smoke_test do
    visit '/'
    home_page = Inquisition::Pages::HomePage.new
    expect(home_page).to be_on_page
  end
end

feature 'Error pages', js: true do
  scenario 'Load custom 404 page', :read_only do
    url = '/404'
    visit url
    home_page = Inquisition::Pages::ErrorPage.new(error_code: 404, url: url)
    expect(home_page).to be_on_page
  end

  scenario 'Load custom 422 page', :read_only do
    url = '/422'
    visit url
    home_page = Inquisition::Pages::ErrorPage.new(error_code: 422, url: url)
    expect(home_page).to be_on_page
  end

  scenario 'Load custom 500 page', :read_only do
    url = '/500'
    visit url
    home_page = Inquisition::Pages::ErrorPage.new(error_code: 500, url: url)
    expect(home_page).to be_on_page
  end

  scenario 'Load a collection that does not exist', :read_only do
    url = '/collections/dne'
    visit url
    home_page = Inquisition::Pages::ErrorPage.new(error_code: 404, url: url)
    expect(home_page).to be_on_page
  end

  scenario 'Load a download that does not exist', :read_only do
    url = '/downloads/dne'
    visit url
    home_page = Inquisition::Pages::ErrorPage.new(error_code: 404, url: url)
    expect(home_page).to be_on_page
  end

  # This currently gives a 500
  xscenario 'Load an item that does not exist', :read_only do
    url = '/items/dne'
    visit url
    home_page = Inquisition::Pages::ErrorPage.new(error_code: 404, url: url)
    expect(home_page).to be_on_page
  end

  scenario 'Load an invalid route', :read_only do
    url = '/route/dne'
    visit url
    home_page = Inquisition::Pages::ErrorPage.new(error_code: 404, url: url)
    expect(home_page).to be_on_page
  end

  scenario 'Load a document that cannot be downloaded', :read_only do
    url = '/downloads/RBSC-INQ:COLLECTION'
    visit url
    home_page = Inquisition::Pages::ErrorPage.new(error_code: 500, url: url)
    expect(home_page).to be_on_page
  end
end
