require 'spec_helper'

feature 'User Browsing', :js => true do
    scenario 'Load homepage' do
      #Setting js_error false will suppress errors coming back from the site and let the tests finish
      page.driver.browser.js_errors = false
      visit '/'
      puts current_url
      within('#main-menu') do
        expect(page).to have_css 'li', count: 6
      end
    end
end
