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
#Capybara.ignore_hidden_elements = false

Capybara.app_host = 'https://curatepprd.library.nd.edu/'

RSpec.configure do |config|
    config.include Capybara::DSL
end

feature 'Browsing', :js => true do
    scenario 'Login to Curate' do
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

        click_on('Log In')
        if expect(page).to have_field 'username', type: 'text'
          print "First login, enter username and password\n"
          fill_in('username', with: 'username')
        else
          expect(page).to have_field 'password', type: 'password'
          print "Trusted device, needs only password\n"
        end

        print "Filling in password next\n"
        fill_in('password', with: 'password')

        print "Logging in with username and password fields\n"
        puts current_url
        click_on('LOGIN')

        within('.mfa-text-wrapper') do
          expect(page).to have_content 'Send'
        end


        print("The next click should send a push to Android (2576)\n")
        expect(page).to have_button 'LOGIN'

        puts current_url
        click_on('LOGIN')
        #Use below syntax if you want to wait
        #click_on('LOGIN', wait: 60)

        # if expect(page).to have_content('Incorrect NetID or password.')
        #   print "Succesfull negative login test"
        # elsif expect(page).to have_content 'Android (2576)'
        #   page.save_screenshot('curate_test_screenshot.png')
        #   print "Succesfull postive login test"
        # end


    end
end
