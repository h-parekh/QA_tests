# frozen_string_literal: true
require 'spec_helper'
require 'contentful/management'
require 'contentful'

Dir.glob(File.expand_path('../pages/**/*.rb', __FILE__)).each do |filename|
  require filename
end

RSpec.configure do |config|
  config.before(:example) do
    InitializeExample.require_release_number
  end
  config.before(:example) do
    InitializeExample.require_contentful_space
  end
end
