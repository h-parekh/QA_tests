require 'rubygems'
#use rspec/autorun only when you need to absolutely run *.rb files using ruby command
#require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/dsl'
require 'capybara/poltergeist'
#HighLine provides a robust system for requesting data from a user
require 'highline/import'
require 'yaml'

Capybara.run_server = false
Capybara.current_driver = :poltergeist
#Capybara.default_max_wait_time = 10 #This sets wait time globally

#If you don't provide this, Capybara will pick  the selenium driver for javascript_driver by default
Capybara.javascript_driver = :poltergeist

#Enable this to work with hidden fields
#Capybara.ignore_hidden_elements = false

cnf = YAML::load_file(File.join(__dir__, 'microfilms_config.yml'))
trigger = YAML::load_file(File.join(__dir__, 'microfilms_trigger.yml'))
target_env = trigger['target']

if target_env.nil? || target_env.to_s == ''
  target_env = ask("Enter target env, options are pprd or prod:  ") { |q| q.echo = true }
end
print cnf[target_env]
Capybara.app_host = cnf[target_env]

#Gives access to the capybara methods
RSpec.configure do |config|
    config.include Capybara::DSL
end

feature 'User Browsing', :js => true do
    scenario 'Test 1: Enter text in search box' do
      visit '/'
      puts current_url
      within('.search') do
        expect(page).to have_field 'q', type: 'text'
        expect(page).to have_button 'search'
        fill_in('q', with: 'Roman')
        click_on('search')
        print "Clicked search\n"
      end

      within('#appliedParams') do
          expect(page).to have_link 'startOverLink'
      end

    end
end
