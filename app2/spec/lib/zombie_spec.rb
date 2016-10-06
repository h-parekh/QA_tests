#This line is autoloaded within rails ecosystem so having it doesnt hurt but may not be necessary
#require 'spec_helper'
#This makes the class zombie required from lib/zombie.rb
require 'Zombie'

describe Zombie do
  it "is named Ash" do
    zombie = Zombie.new
    expect(zombie.name).to  eq('Ash')
  end
end
