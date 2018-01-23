# frozen_string_literal: true

require 'primo/primo_spec_helper'

feature 'User browsing', js: true do
  scenario 'Load homepage', :smoke_test do
    page.driver.browser.js_errors = false
    visit '/'
    home_page = Primo::Pages::HomePage.new
    expect(home_page).to be_on_page
  end
end
