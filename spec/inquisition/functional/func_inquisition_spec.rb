# frozen_string_literal: true
require 'inquisition/inquisition_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Load Homepage', :read_only, :smoke_test do
    page.driver.browser.js_errors = false
    visit '/'
    home_page = Inquisition::Pages::HomePage.new
    expect(home_page).to be_on_page
  end
end
