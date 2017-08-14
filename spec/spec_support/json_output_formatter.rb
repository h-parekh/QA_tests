# frozen_string_literal: true
require 'rspec/core/formatters/json_formatter'
require 'rspec/core/formatters/console_codes'

# This class injects custom variables by calling the same method of parent class JsonFormatter
class JsonOutputFormatter < RSpec::Core::Formatters::JsonFormatter
  # Register ReportFormatter as a formatter with the rspec methods provided by JsonFormatter
  # https://github.com/rspec/rspec-core/blob/master/lib/rspec/core/formatters/json_formatter.rb
  RSpec::Core::Formatters.register self

  def close(notification)
    if @output_hash.fetch(:messages).find{ |e| /31mLoadError/ =~ e }.nil?
      @output_hash[:runID] ||= "#{RunIdentifier.get}"
      report_json_result
    end
    output.write JSON.pretty_generate(@output_hash)
  end

  def report_json_result
    CloudwatchEventHandler.report_json_result(output_hash: @output_hash)
  end
end
