require 'rubygems'
#require 'capybara'
require 'capybara/rspec'
require 'rspec/autorun'
require 'capybara/dsl'
require 'capybara/poltergeist'

Capybara.run_server = false
Capybara.current_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

Capybara.app_host = 'http://www.google.com'

RSpec.configure do |config|
    config.include Capybara::DSL
end

feature 'Load homepage', :js => true do
    scenario 'lets user load homepage' do
        visit '/'
        expect(page).to have_content "Feeling Lucky"
    end
end

# module MyCapybaraTest
#   class Test
#     include Capybara::DSL
#     def test_google
#       visit('/')
#       puts(page.html)
#     end
#   end
# end
#
# t = MyCapybaraTest::Test.new
# t.test_google
