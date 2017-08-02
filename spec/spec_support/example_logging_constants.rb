# frozen_string_literal: true

# Extracted to separate location to assist in ./bin/run_tests to work.
module ExampleLogging
  DEFAULT_ENVIRONMENT = 'prod'.freeze
  DEFAULT_LOG_LEVEL = 'info'.freeze
  AVAILABLE_LOG_LEVELS = %w(debug info warn error fatal).freeze
  DISALLOWED_NETWORK_TRAFFIC_REGEXP = /\.example\.com\//.freeze
end
