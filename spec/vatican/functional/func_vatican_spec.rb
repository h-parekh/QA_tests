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
    first(:css, "i.material-icons.topic-checkbox").trigger('click')
    expect(page).to have_content "Catholic Social Teaching"
  end
  scenario 'Clear Selected Topic' do
    page.driver.browser.js_errors = false
    visit '/'
    click_on("Search The Database")
    search_page = Vatican::Pages::SearchPage.new
    expect(search_page).to be_on_page
    first(:css, "i.material-icons.topic-checkbox").trigger('click')
    expect(page).to have_content "Catholic Social Teaching"
    within("div.col-sm-3.left-col") do
      find_button("Clear").trigger('click')
    end
    page.should have_no_content("Catholic Social Teaching")

  end
  scenario 'Search Results Divided into Columns' do
    page.driver.browser.js_errors = false
    visit '/'
    click_on("Search The Database")
    search_page = Vatican::Pages::SearchPage.new
    expect(search_page).to be_on_page
    node = first(:css, "input")
    node.set("Vatican")
    within("div.col-sm-10") do
      find_button("search").trigger('click')
    end
    expect(page).to have_content("Catholic Social Teaching")
    expect(page).to have_content("International Human Rights Law")

  end
  scenario 'Access Entire Document' do
    page.driver.browser.js_errors = false
    visit '/'
    click_on("Search The Database")
    search_page = Vatican::Pages::SearchPage.new
    expect(search_page).to be_on_page
    node = first(:css, "input")
    node.set("Vatican")
    within("div.col-sm-10") do
      find_button("search").trigger('click')
    end
    expect(page).to have_content("Catholic Social Teaching")
    expect(page).to have_content("International Human Rights Law")
    within("div.search-list.results") do
      first("a").trigger('click')
      sleep(6)
    end
    expect(page).to have_content("Topics in Document")
  end
  scenario 'Sort Newest To Oldest' do
    page.driver.browser.js_errors = false
    visit '/'
    click_on("Search The Database")
    search_page = Vatican::Pages::SearchPage.new
    expect(search_page).to be_on_page
    node = first(:css, "input")
    node.set("Vatican")
    within("div.col-sm-10") do
      find_button("search").trigger('click')
    end
    expect(page).to have_content("Catholic Social Teaching")
    expect(page).to have_content("International Human Rights Law")
    within("div.search-list.results") do
      first("a").trigger('click')
    end

    sleep(7)
    expect(page).to have_content("View PDF")
  end
end
