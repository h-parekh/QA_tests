require 'rails/all'
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'
require 'capybara/rspec'
#enables capybara use in unsupported testing frameworks, and for general-purpose scripting
require 'capybara/dsl'



# Needed for using phrases like 'visit '/'', 'fill_in', 'click_button' in the tests
RSpec.configure do |config|
  config.include Capybara::DSL
end
