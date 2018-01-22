# frozen_string_literal: true
require 'spec_helper'
require File.expand_path('../pages/base_page.rb', __FILE__)
Dir.glob(File.expand_path('../pages/**/*.rb', __FILE__)).each do |filename|
  require filename
end
