# frozen_string_literal: true
require 'spec_helper'

require File.expand_path('../pages/base_page.rb', __FILE__)
Dir.glob(File.expand_path('../pages/**/*.rb', __FILE__)).each do |filename|
  require filename
end

Dir.glob(File.expand_path('../utilities/**/*.rb', __FILE__)).each do |filename|
  require filename
end

Capybara.register_driver :poltergeist do |app|
  options = {
       phantomjs_options: [
         '--ssl-protocol=tlsv1.2'
       ]
     }
  Capybara::Poltergeist::Driver.new(app, options)
end

RSpec.configure do |config|
  config.before(:example) do
    InitializeExample.require_version_number
  end
end
