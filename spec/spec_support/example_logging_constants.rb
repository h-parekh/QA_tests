# frozen_string_literal: true

# Extracted to separate location to assist in ./bin/run_tests to work.
module ExampleLogging
  DEFAULT_ENVIRONMENT = 'prod'
  DEFAULT_LOG_LEVEL = 'info'
  AVAILABLE_LOG_LEVELS = %w(debug info warn error fatal).freeze
end
