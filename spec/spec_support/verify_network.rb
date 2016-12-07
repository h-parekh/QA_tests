# frozen_string_literal: true
module VerifyNetwork
  Logging.logger.root.appenders = Logging.appenders.stdout
  Logging.logger.root.level = :info
  @@log = Logging.logger['curate']

  module_function

  def verify_network_traffic(page, test_handler)
    message_builder = lambda do |array|
      text = "Resource Error:"
      array.each do |obj|
        text += "\n\tStatus: #{obj.fetch(:status)}\tURL: #{obj.fetch(:url)}"
      end
      text
    end
    @@log.info "Verify Network traffic"
    failed_resources = []
    page.driver.network_traffic.each do |request|
      request.response_parts.uniq(&:url).each do |response|
        @@log.debug "Process resource #{response.url} with status #{response.status}"
        if (400..599).cover? response.status
          resource_hash = { url: response.url, status_code: response.status }
          failed_resources << resource_hash
        end
      end
      test_handler.expect(failed_resources).to test_handler.be_empty, message_builder.call(failed_resources)
    end
  end
end
