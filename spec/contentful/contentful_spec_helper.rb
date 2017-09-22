# frozen_string_literal: true
require 'spec_helper'
require 'contentful/management'
require 'contentful'

Dir.glob(File.expand_path('../pages/**/*.rb', __FILE__)).each do |filename|
  require filename
end
