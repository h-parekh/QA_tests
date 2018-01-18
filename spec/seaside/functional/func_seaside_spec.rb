# frozen_string_literal: true
require 'seaside/seaside_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Load Homepage', :read_only do
    visit '/'
    home_page = Seaside::Pages::HomePage.new
    expect(home_page).to be_on_page
  end
end
