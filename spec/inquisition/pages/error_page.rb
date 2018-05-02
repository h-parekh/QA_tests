# frozen_string_literal: true

require 'inquisition/inquisition_spec_helper'

module Inquisition
  module Pages
    class ErrorPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      attr_reader :error_code, :url

      def initialize(error_code:, url:)
        VerifyNetworkTraffic.exclude_uri_from_network_traffic_validation.push(url.to_s)
        @error_code = error_code
        @url = url
      end

      def on_page?
        status_response_ok? &&
          has_title? &&
          on_valid_url?
      end

      def status_response_ok?
        status_code == error_code
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, url)
      end

      def has_title?
        within('.dialog') do
          case error_code
          when 404
            has_content?("The page you were looking for doesn't exist.")
          when 422
            has_content?("The change you wanted was rejected.")
          else
            has_content?("We're sorry, but something went wrong.")
          end
        end
      end
    end
  end
end
