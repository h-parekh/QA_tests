module VerifyAsset
  extend Capybara::DSL

  module_function

  def verify_network_traffic(page)
    Logging.logger.root.appenders = Logging.appenders.stdout
    Logging.logger.root.level = :info

    log = Logging.logger['curate']
    log.info "Verify Network traffic"
    failed_resources = []
    page.driver.network_traffic.each do |request|
      request.response_parts.uniq(&:url).each do |response|
        log.info "Process resource #{response.url} with status #{response.status}"
        if (400..599).cover? response.status
          resource_hash = { url: response.url, status_code: response.status }
          failed_resources << resource_hash
        end
      end
      unless failed_resources.empty?
        log.error "Following resources failed to load: #{failed_resources.inspect}"
      end
    end
    page.driver.reset!
  end
end
