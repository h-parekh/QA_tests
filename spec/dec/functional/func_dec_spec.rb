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
    expect(home_page).to be_on_collections_page
  end
 end