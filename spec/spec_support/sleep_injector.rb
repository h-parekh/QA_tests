# frozen_string_literal = true
require 'capybara/node/actions'
require 'capybara/dsl'
# This class adds a sleep statement at the end of the click_on class for

module SleepInjector
  include Capybara::Node::Actions
  include Capybara::DSL
  def click_link_or_button(locator = nil, options = {})
    super
    sleep(2)
  end
  alias click_on click_link_or_button
end
