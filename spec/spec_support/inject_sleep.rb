# frozen_string_literal: true
require "capybara/rspec/matchers"
require "capybara/node/matchers"
class Capybara::RSpecMatchers::Matcher
  def wrap_matches?(actual)
    wrapped_actual = wrap(actual)
    yield(wrapped_actual)
  rescue Capybara::ExpectationNotMet => e
    # if error
    sleep(3)
    begin
      yield(wrapped_actual)
    rescue Capybara::ExpectationNotMet => e
      # if still error
      sleep(10)
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
    assert_selector(*args, &optional_filter_block)
  rescue Capybara::ExpectationNotMet, Exception => e
    # if error
    sleep(3)
    begin
      assert_selector(*args, &optional_filter_block)
    rescue Capybara::ExpectationNotMet
      # if still error
      sleep(10)
      begin
        assert_selector(*args, &optional_filter_block)
      rescue Capybara::ExpectationNotMet
        return false
      end
    end
  end
end

module Capybara::Node::Matchers
  def has_no_selector?(*args, &optional_filter_block)
    assert_no_selector(*args, &optional_filter_block)
  rescue Capybara::ExpectationNotMet, Exception => e
    # if error
    sleep(3)
    begin
      assert_no_selector(*args, &optional_filter_block)
    rescue Capybara::ExpectationNotMet
      # if still error
      sleep(10)
      begin
        assert_no_selector(*args, &optional_filter_block)
      rescue Capybara::ExpectationNotMet
        return false
      end
    end
  end
end
