# NDlib QA Tests

These tests will be deployed to the remote machine testcontroller01.library.nd.edu
You can run these tests against the environments specified in the application's YAML config file

## Setup Notes
Your local machine will need the following setup to be able to run these tests from the local machine.

Git for version control
Bundler for managing Ruby libraries
Rbenv for managing versions of Ruby
Ruby 2.3.1
Airborne 0.2.7 - for testing API endpoints
Capybara 2.10.1 - for testing web applications
Phantomjs 2.1.1 - for supporting capybara/poltergeist to capture screenshots
Poltergeist 1.11.0 - chosen web driver for using with capybara
Nokogiri 1.6.8.1 - for XML tree parsing and navigation


## Running the tests

``` console
ENVIRONMENT=prod rspec spec/r_spec.rb
```
