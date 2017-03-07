# frozen_string_literal: true
require 'rspec/core/formatters/json_formatter'

# This class injects custom variables by calling the same method of parent class JsonFormatter
class JsonOutputFormatter < RSpec::Core::Formatters::JsonFormatter
  # Register ReportFormatter as a formatter with the rspec methods provided by JsonFormatter
  # https://github.com/rspec/rspec-core/blob/master/lib/rspec/core/formatters/json_formatter.rb
  RSpec::Core::Formatters.register self

  def stop(notification)
    super
    @output_hash[:runID] ||= "#{RunIdentifier.get}"
    report_json_result
  end

  def report_json_result
    CloudwatchEventHandler.report_json_result(output_hash: @output_hash)
  end
end
