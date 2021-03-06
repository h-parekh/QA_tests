# frozen_string_literal: true

require 'vatican/vatican_spec_helper'
feature "User Browsing", :read_only, js: true do
  scenario 'Load Homepage' do
    visit '/'
    home_page = Vatican::Pages::HomePage.new
    expect(home_page).to be_on_page
  end

  scenario 'Go to "How To Use Database" page', :read_only do
    visit '/'
    click_on('How To Use the Database')
    instructions_page = Vatican::Pages::InstructionsPage.new
    expect(instructions_page).to be_on_page
  end

  scenario 'Load "Search the Database" page', :read_only do
    visit '/'
    click_on("Search The Database")
    search_page = Vatican::Pages::SearchPage.new
    expect(search_page).to be_on_page
  end

  scenario 'Validate navigation menu on search page', :read_only do
    visit '/'
    click_on("Search The Database")
    search_page = Vatican::Pages::SearchPage.new
    expect(search_page).to be_on_page
  end

  scenario 'Check a box in "Search By Topic"', :read_only do
    visit '/'
    click_on("Search The Database")
    search_page = Vatican::Pages::SearchPage.new
    expect(search_page).to be_on_page
    first(:css, "i.material-icons.topic-checkbox").click
    expect(page).to have_content("Catholic Social Teaching")
  end

  scenario 'Clear Selected Topic', :read_only do
    visit '/'
    click_on("Search The Database")
    search_page = Vatican::Pages::SearchPage.new
    expect(search_page).to be_on_page
    first(:css, "i.material-icons.topic-checkbox").click
    expect(page).to have_content "Catholic Social Teaching"
    within("div.col-sm-3.left-col") do
      find_button("Clear").click
    end
    expect(page).to have_no_content("Catholic Social Teaching")
  end

  scenario 'Search Results Divided into Columns', :read_only do
    visit '/'
    click_on("Search The Database")
    search_page = Vatican::Pages::SearchPage.new
    expect(search_page).to be_on_page
    node = first(:css, "input")
    node.set("Vatican")
    within("div.col-sm-10") do
      find_button("search").click
    end
    expect(page).to have_content("Catholic Social Teaching")
    expect(page).to have_content("document(s) found")
    expect(page).to have_content("International Human Rights Law")
  end

  scenario 'Access Entire Document', :read_only do
    visit '/'
    click_on("Search The Database")
    search_page = Vatican::Pages::SearchPage.new
    expect(search_page).to be_on_page
    node = first(:css, "input")
    node.set("Vatican")
    within(first("div.col-sm-4")) do
      find_button("search").click
    end
    expect(page).to have_content("Catholic Social Teaching")
    expect(page).to have_content("document(s) found")
    expect(page).to have_content("International Human Rights Law")
    within("div.search-list.results") do
      first("a").click
    end
    expect(page).to have_content("Topics in Document")
  end

  scenario 'Sort Newest To Oldest', :read_only do
    visit '/'
    click_on("Search The Database")
    search_page = Vatican::Pages::SearchPage.new
    expect(search_page).to be_on_page
    node = first(:css, "input")
    node.set("Vatican")
    within(first("div.col-sm-4")) do
      find_button("search").click
    end
    expect(page).to have_content("Catholic Social Teaching")
    expect(page).to have_content("document(s) found")
    expect(page).to have_content("International Human Rights Law")
    find('option', text: "Date New-Old").click
    expect(page).to have_content("Catholic Social Teaching")
  end
end
