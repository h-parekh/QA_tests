require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

Capybara.run_server = false
Capybara.current_driver = :poltergeist
Capybara.app_host = 'http://www.google.com'

module MyCapybaraTest
  class Test
    include Capybara::DSL
    def test_google
      visit('/')
      puts(page.html)
    end
  end
end

t = MyCapybaraTest::Test.new
t.test_google
