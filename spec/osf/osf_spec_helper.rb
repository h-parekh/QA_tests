# frozen_string_literal: true
require 'spec_helper'
Dir.glob(File.expand_path('../pages/**/*.rb', __FILE__)).each do |filename|
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
