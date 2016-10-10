require 'rubygems'
require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/dsl'
require 'capybara/poltergeist'
#HighLine provides a robust system for requesting data from a user
require 'highline/import'

Capybara.run_server = false
Capybara.current_driver = :poltergeist
#Capybara.default_max_wait_time = 10 #This sets wait time globally

#If you don't provide this, Capybara will pick  the selenium driver for javascript_driver by default
Capybara.javascript_driver = :poltergeist

#Enable this to work with hidden fields
#Capybara.ignore_hidden_elements = false

Capybara.app_host = 'https://curatepprd.library.nd.edu/'

#Gives access to the capybara methods
RSpec.configure do |config|
    config.include Capybara::DSL
end

feature 'User login', :js => true do
    scenario 'Test 1: Login to Curate with correct credentials' do
        visit '/'
        expect(page).to have_link 'Log In'

#Using the same has_link assertion with options
        #expect(page).to have_link 'Log In', href: '/users/sign_in'

#To print the html:
        #puts(page.html)
        #print page.html

#Take screenshot of the page, save_and_open_screenshot needs launchy gem
        #page.save_screenshot('curate_test_screenshot.png')
        #page.save_and_open_screenshot('curate_test_screenshot2.png')

        click_on('Log In')
        if expect(page).to have_field 'username', type: 'text'
          #getting username using highline gem syntax
          p_username = ask("Enter valid username:  ") { |q| q.echo = true }
          fill_in('username', with: p_username)
        else
          expect(page).to have_field 'password', type: 'password'
          print "Trusted device, needs only password\n"
        end

        #getting password using highline gem syntax
        p_password = ask("Enter valid password:  ") { |q| q.echo = "*" }
        fill_in('password', with: p_password)

        print "Logging in with username and password fields\n"
        puts current_url
        click_on('LOGIN')

#Accessing a specific xpath and running a validation
        within('.mfa-text-wrapper') do
          expect(page).to have_content 'Send'
        end


        print("The next click should send a push to Android\n")
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

    scenario 'Test 2: Login to Curate with incorrect credentials' do
                visit '/'
                expect(page).to have_link 'Log In'
                click_on('Log In')
                if expect(page).to have_field 'username', type: 'text'
                  #getting username using highline gem syntax
                  p_username = ask("Enter INVALID username:  ") { |q| q.echo = true }
                  fill_in('username', with: p_username)
                else
                  expect(page).to have_field 'password', type: 'password'
                  print "Trusted device, needs only password\n"
                end

                #getting password using highline gem syntax
                p_password = ask("Enter INVALID password:  ") { |q| q.echo = "*" }
                fill_in('password', with: p_password)

                print "Logging in with username and password fields\n"

                click_on('LOGIN')
                if expect(page).to have_content 'Incorrect NetID or password.'
                  print "Successfully tested login with invalid creds"
                end
    end

end
