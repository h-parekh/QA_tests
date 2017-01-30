# frozen_string_literal: true
require 'vatican/vatican_spec_helper'
feature "User Browsing", js: true do
  scenario 'Load Homepage' do
    page.driver.browser.js_errors = false
    visit '/'
    home_page = Vatican::Pages::HomePage.new
    expect(home_page).to be_on_page
  end

  scenario 'How To Use Database page' do
    page.driver.browser.js_errors = false
    visit '/'
    click_on('How To Use the Database')
    instructions_page = Vatican::Pages::InstructionsPage.new
    expect(instructions_page).to be_on_page
  end

  scenario 'Load Search the Database page' do
    page.driver.browser.js_errors = false
    visit '/'
    click_on("Search The Database")
    search_page = Vatican::Pages::SearchPage.new
    expect(search_page).to be_on_page
  end
  scenario 'Access Navigation Menu' do
    page.driver.browser.js_errors = false
    visit '/'
    click_on("Search The Database")
    search_page = Vatican::Pages::SearchPage.new
    expect(search_page).to be_on_page
    #find(".material_icon").click
    within("nav") do
      expect(page).to have_css "a", count: 7
    end
  end
  scenario 'Search By Topic' do
    page.driver.browser.js_errors = false
    visit '/'
    click_on("Search The Database")
    search_page = Vatican::Pages::SearchPage.new
    expect(search_page).to be_on_page
    find(:css, "i.material_icon.topic_checkbox").click
    expect(page).to have_content "Catholic Social Teaching"
  end
end
