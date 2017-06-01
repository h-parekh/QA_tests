# frozen_string_literal: true
require "capybara/rspec/matchers"
require "capybara/node/matchers"
class Capybara::RSpecMatchers::Matcher
  def wrap_matches?(actual)
    puts "&" *80
    wrapped_actual = wrap(actual)
    yield(wrapped_actual)
  rescue Capybara::ExpectationNotMet => e
    puts "*" * 80
    sleep(3)
    begin
      yield(wrapped_actual)
    rescue Capybara::ExpectationNotMet => e
      puts "$" * 80
      sleep(30)
      begin
        yield(wrapped_actual)
      rescue Capybara::ExpectationNotMet => e
        @failure_message = e.message
        return false
      end
    end
  end
end

module Capybara::Node::Matchers
  def has_selector?(*args, &optional_filter_block)
    puts "%" * 80
    assert_selector(*args, &optional_filter_block)
  rescue Capybara::ExpectationNotMet, Exception => e
    puts "@" *80
    sleep(3)
    begin
      assert_selector(*args, &optional_filter_block)
    rescue Capybara::ExpectationNotMet
      puts "+"*80
      sleep(10)
      begin
        assert_selector(*args, &optional_filter_block)
      rescue Capybara::ExpectationNotMet
        return false
      end
    end
  end
end
