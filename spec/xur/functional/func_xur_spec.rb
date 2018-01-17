# frozen_string_literal: true

require 'xur/xur_spec_helper'

feature 'Load home page', js: true do
  scenario 'Check version', :smoke_test do
    visit '/'
    home_page = XUR::Pages::HomePage.new
    expect(home_page).to be_on_page
  end
end
