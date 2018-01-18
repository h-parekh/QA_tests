# frozen_string_literal: true

module Buzz
  class BuzzPlayer
    include Capybara::DSL
    include CapybaraErrorIntel::DSL

    def valid_response?
      @json_response = JSON.parse(page.text)
      is_url_key_valid? &&
        is_embed_url_key_valid? &&
        is_content_url_key_valid?
    end

    # Checks if the 'url' field of JSON response is set correctly
    def is_url_key_valid?
      @json_response.fetch('url') == current_url
    end

    # embedUrl is the link used by other applications to stream media from buzz
    # For example in this case, https://collections.library.nd.edu/7eff2d10c7/freshwriting-multimedia/items/10595b52e8
    # This method ensures that the ID in current_url is set correctly in the value for 'embedUrl' key
    def is_embed_url_key_valid?
      embed_url_value = @json_response.fetch('embedUrl')
      query_params = URLHandler.extract_query_parameters_from_url(embed_url_value)
      current_url.include?(query_params.fetch('id'))
    end

    # values for contentURl key must be a valid wowza URL
    def is_content_url_key_valid?
      @json_response.fetch('contentUrl').all? { |each_url| !each_url.match('wowza.library.nd.edu').nil? }
    end
  end
end
