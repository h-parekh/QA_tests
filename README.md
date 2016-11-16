# NDlib QA Tests
> A place to collect all types of test suites for HesLib web application and APIs

These tests will be deployed to the remote machine testcontroller01.library.nd.edu
You can run these tests against the environments specified in the application's YAML config file

## Setup Notes
Your local machine will need the following setup to be able to run these tests from the local machine.

1. Git for version control
2. Bundler for managing Ruby libraries
3. Rbenv for managing versions of Ruby
4. Ruby 2.3.1
5. Airborne 0.2.7 - for testing API endpoints
6. Capybara 2.10.1 - for testing web applications
7. Phantomjs 2.1.1 - for supporting capybara/poltergeist to capture screenshots
8. Poltergeist 1.11.0 - chosen web driver for using with capybara
9. Nokogiri 1.6.8.1 - for XML tree parsing and navigation
10. Verify that `ssh app@testcontroller01.library.nd.edu` works

?? Can we package these in some way ??

## Deploying master branch from local to remote testcontroller01
``` console
cd git/QA_tests
git branch master
cap production deploy
```
?? We may want to consider setting up Capistrano to deploy non-master branches

## Running the tests on remote
ssh into testcontroller01.library.nd.edu as 'app' user and run below commands:
``` console
cd /home/app/QA_tests/current
ENVIRONMENT=prod rspec spec/<app_name>/<type_of_test>/r_spec.rb
```
Example for running the functional test against curate prod:
``` console
cd /home/app/QA_tests/current
ENVIRONMENT=prod rspec spec/curate/functional/func_curate_spec.rb
```
