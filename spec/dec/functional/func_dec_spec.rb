# frozen_string_literal: true

require 'dec/dec_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Select a collection', :read_only, :smoke_test do
    visit '/'
    home_page = Dec::Pages::HomePage.new
    expect(home_page).to be_on_page
    home_page.click_collections_page
    collections_page = Dec::Pages::CollectionsPage.new
    expect(collections_page).to be_on_page
    collections_page.click_forward_arrow
    expect(page).to have_selector("div", id: "page-show")
  end
end
