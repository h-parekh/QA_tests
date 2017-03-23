require 'dec/dec_spec_helper'

feature 'User Browsing', js: true do
  scenario 'DEC_1', :read_only do
    visit '/'
    home_page = Dec::Pages::HomePage.new
    expect(home_page).to be_on_page
  end

  scenario 'DEC_2', :read_only do
    visit '/'
    home_page = Dec::Pages::HomePage.new
    expect(home_page).to be_on_page
    first('span', {text: 'Explore', visible: false}).click
    sleep(5)
    collections_page = Dec::Pages::CollectionsPage.new
    expect(collections_page).to be_on_page
  end

  scenario 'DEC_3', :read_only do
    visit '/'
    home_page = Dec::Pages::HomePage.new
    first('span', {text: 'Explore', visible: false}).click
    collections_page = Dec::Pages::CollectionsPage.new
    sleep(5)
    expect(collections_page).to be_on_page
    first('span', {text: 'arrow_forward'}).trigger('click')
  end
 end
