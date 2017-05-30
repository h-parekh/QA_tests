# frozen_string_literal: true
require 'capybara/node/element'
# This class adds a sleep statement at the end of the click_on class for

class Capybara::Node::Element
  # Method wrapping for the .click method to add sleep statement
  old_click = instance_method(:click)
  define_method(:click) do
    old_click.bind(self).call
    sleep(2)
  end

  # Method wrapping for the .trigger(event) method to add sleep statement
  old_trigger = instance_method(:trigger)
  define_method(:trigger) do |event|
    old_trigger.bind(self).call(event)
    sleep(3)
  end
end
