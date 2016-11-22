
# frozen_string_literal: true
require 'rubygems'
require 'capybara/rspec'
require 'capybara/dsl'
require 'capybara/poltergeist'

Capybara.run_server = false
Capybara.current_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

Capybara.app_host = 'https://collections-pprd.library.nd.edu/'

RSpec.configure do |config|
  config.include Capybara::DSL
end

# Visiting Digital Exhibits and Collections - home page of Beehive.
print "Testing"

feature 'Load homepage', js: true do
  scenario 'lets user load Beehive homepage' do
    visit '/'
    puts current_url

    within('#content') do
      expect(page).to have_text "Featured Collections"
    end
  end
end
