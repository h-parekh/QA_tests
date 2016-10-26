require 'spec_helper'

app_name = 'rbsc'
config_file = app_name + '_config.yml'
trigger_file = app_name + '_trigger.yml'

cnf = YAML::load_file(File.join(__dir__, config_file))
trigger = YAML::load_file(File.join(__dir__, trigger_file))
target_env = trigger['target']
if target_env.nil? || target_env.to_s == ''
  target_env = ask("Enter target env, options are pprd or prod:  ") { |q| q.echo = true }
end

Capybara.app_host = cnf[target_env]


#Gives access to the capybara methods
RSpec.configure do |config|
    config.include Capybara::DSL
end

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
