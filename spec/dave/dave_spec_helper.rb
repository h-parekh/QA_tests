require 'spec_helper'
Dir.glob(File.expand_path('../pages/**/*.rb', __FILE__)).each do |filename|
  require filename
end
