require 'capybara'
require 'capybara/rspec'
require 'rspec/autorun'
require 'capybara/poltergeist'
#require 'rspec/rails'
#require 'rails/all'
#require 'capybara/rails'


#enables capybara use in unsupported testing frameworks, and for general-purpose scripting
require 'capybara/dsl'

# setting the default driver to webkit
Capybara.default_driver = :poltergeist

#THis can be any web server running on the internet
Capybara.app_host = 'http://www.google.com'

#Setting to false since by default Capybara will try to boot a rack application automatically
Capybara.run_server = false

# Needed for using phrases like 'visit '/'', 'fill_in', 'click_button' in the tests
RSpec.configure do |config|
    config.include Capybara::DSL
end
