require 'dave/dave_spec_helper'

Capybara.current_driver = :webkit
Capybara.javascript_driver = :webkit

feature 'DAVE artifact viewing', js: true do
  scenario 'Load 1st example' do
    visit '/0/MSN-COL_9101-1-B/0/1/0'
    expect(page).to have_content('Essex County')
    expect(page.current_url).to eq ('http://testlibnd-dave.s3-website-us-east-1.amazonaws.com/0/MSN-COL_9101-1-B/0/1/0')
  end
end
