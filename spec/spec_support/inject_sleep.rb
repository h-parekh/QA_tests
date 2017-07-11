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
      puts '*' * 80
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

module Capybara::Node::Actions
  def fill_in(locator, options={})
    locator, options = nil, locator if locator.is_a? Hash
    raise "Must pass a hash containing 'with'" if not options.is_a?(Hash) or not options.has_key?(:with)
    with = options.delete(:with)
    fill_options = options.delete(:fill_options)
    options[:with] = options.delete(:currently_with) if options.has_key?(:currently_with)
    find(:fillable_field, locator, options).set(with, fill_options)
    sleep(2)
    # solves the issue of nonworking click statements after fill_in statements
  end
end
