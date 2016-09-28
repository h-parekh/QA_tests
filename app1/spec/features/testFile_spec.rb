require 'spec_helper'

# setting the default driver to webkit
Capybara.default_driver = :webkit

#THis can be any web server running on the internet
Capybara.app_host = 'http://www.google.com'

#Setting to false since by default Capybara will try to boot a rack application automatically
Capybara.run_server = false

feature 'Load homepage', :js => true do
  scenario 'lets user load homepage' do
    visit '/'
    expect(page).to have_content "I'm Feeling Lucky"
  end
end
