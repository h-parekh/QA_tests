require 'rubygems'
require 'capybara/rspec'
require 'rspec/autorun'
require 'capybara/dsl'
require 'capybara/poltergeist'

Capybara.run_server = false
Capybara.current_driver = :poltergeist
# Capybara.default_max_wait_time = 10

#If you don't provide this, Capybara will pick  the selenium driver for javascript_driver by default
Capybara.javascript_driver = :poltergeist

Capybara.app_host = 'https://curatepprd.library.nd.edu/'

RSpec.configure do |config|
    config.include Capybara::DSL

end

feature 'Browsing', :js => true do
    scenario 'Step 1: User loads homepage' do
        visit '/'

        #To print the html:
        #puts(page.html)
        # print page.html

        #Take screenshot of the page, save_and_open_screenshot needs launchy gem
        page.save_screenshot('curate_test_screenshot.png')
        #page.save_and_open_screenshot('curate_test_screenshot2.png')
        #expect(page).to have_content "Feeling Lucky"

        #page.should have_selector(:link_or_button, 'Log In')
        expect(page).to have_link 'Log In'
        click_on('Log In')
        page.save_screenshot('curate_LoginPage_screenshot.png')
        #expect(page).to have_link 'Log In', href: '/users/sign_in'


    end
    #
    # scenario 'Step2: Click Log in' do
    #   print page.html
    #   # click_link_or_button('Log In')
    #   # page.save_screenshot('curate_LoginPage_screenshot.png')
    # end
end
