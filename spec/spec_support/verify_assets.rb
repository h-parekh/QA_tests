module VerifyAsset
  module_function

  def verify_network_traffic
    failed_resources = []
    page.driver.network_traffic.each do |request|
      request.response_parts.uniq(&:url).each do |response|
        if (400..599).cover? response.status
          resource_hash = { url: response.url, status_code: response.status }
          failed_resources << resource_hash
        end
      end
      return failed_resources
    end
  end
end
