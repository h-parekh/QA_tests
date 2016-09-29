require 'rubygems'
require 'capybara/rspec'
require 'rspec/autorun'
require 'capybara/dsl'
require 'capybara/poltergeist'

Capybara.run_server = false
Capybara.current_driver = :poltergeist
#Capybara.default_max_wait_time = 10 #This sets wait time globally

#If you don't provide this, Capybara will pick  the selenium driver for javascript_driver by default
Capybara.javascript_driver = :poltergeist

Capybara.app_host = 'https://curatepprd.library.nd.edu/'

RSpec.configure do |config|
    config.include Capybara::DSL

end

feature 'Browsing', :js => true do
    scenario 'Step 1: User loads homepage' do
        visit '/'
        expect(page).to have_link 'Log In'
        #Using the same has_link assertion with options
        #expect(page).to have_link 'Log In', href: '/users/sign_in'
        #To print the html:
        #puts(page.html)
        # print page.html

        #Take screenshot of the page, save_and_open_screenshot needs launchy gem
        #page.save_screenshot('curate_test_screenshot.png')
        #page.save_and_open_screenshot('curate_test_screenshot2.png')

        #page.should have_selector(:link_or_button, 'Log In')

        click_on('Log In')
        if expect(page).to have_field 'username', type: 'text'
          print "First login, enter username and password\n"
          fill_in('username', with: 'johndoe')
        else
          expect(page).to have_field 'password', type: 'password'
          print "Trusted device, needs only password\n"
        end

        print "Filling in password next\n"
        fill_in('password', with: 'johndoe password')

        print "Need some form of basic auth logic"
        click_on('LOGIN')

        # if expect(page).to have_link 'Log Out'
        #   print "Logged in succesfully)"
        #   page.save_screenshot('curate_LoginPage_screenshot.png')
        # end
    end
end
