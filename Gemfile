source 'https://rubygems.org'
gem 'capistrano'
gem 'capistrano-bundler'
gem 'rake'

# Gems in the testcontroller group are required to be built before test runtime
# but not at the time of deployment via Jenkins.
# Jenkins deploy job is setup with:
# bundle install --deployment --without testcontroller
group :testcontroller do
  gem 'activesupport'
  gem 'airborne'
  gem 'aws-sdk'
  gem 'bunyan_capybara'
  gem 'byebug'
  gem 'capybara'
  gem 'capybara-maleficent'
  gem 'capybara-screenshot'
  gem 'capybara_error_intel'
  gem 'contentful'
  gem 'contentful-management'
  gem 'google_drive'
  gem 'logging'
  gem 'poltergeist'
  gem 'rspec'
  gem 'rubocop', require: false
  gem 'rubocop-rspec'
  gem 'selenium-webdriver'
  gem 'swagger-parser'
end
