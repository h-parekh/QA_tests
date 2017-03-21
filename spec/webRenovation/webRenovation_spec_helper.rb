# frozen_string_literal: true
require 'spec_helper'
Dir.glob(File.expand_path('../pages/**/*.rb', __FILE__)).each do |filename|
  require filename
end

Dir.glob(File.expand_path('../utilities/**/*.rb', __FILE__)).each do |filename|
  require filename
end
