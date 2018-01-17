# frozen_string_literal: true

module URLHandler
  # Return the query parameters from given URL
  # @param [String] url
  # @return [Hash]
  def self.extract_query_parameters_from_url(url)
    Rack::Utils.parse_query(URI(url).query)
  end
end
