source 'https://rubygems.org'
gem 'capistrano'
gem 'capistrano-bundler'
gem 'rake'

# Gems in the testcontroller group are required to be built before test runtime
# but not at the time of deployment via Jenkins.
# Jenkins deploy job is setup with:
# bundle install --deployment --without testcontroller
group :testcontroller do
  gem 'rspec'
  gem 'activesupport'
  gem 'capybara'
  gem 'poltergeist'
  gem 'capybara_error_intel'
  gem 'capybara-maleficent'
  gem 'rubocop', require: false
  gem 'rubocop-rspec'
  gem 'capybara-screenshot'
  gem 'logging'
  gem 'byebug'
  gem 'selenium-webdriver'
  gem 'swagger-parser'
  gem 'aws-sdk'
  gem 'airborne'
  gem 'contentful'
  gem 'google_drive'
  gem 'contentful-management'
  gem "bunyan"
end
