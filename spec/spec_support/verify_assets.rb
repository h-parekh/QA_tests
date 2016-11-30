require File.expand_path('../../spec_helper', __FILE__)

module VerifyAsset
  module_function
  def network_traffic(url)
    session = Capybara::Session.new(:poltergeist)
    session.visit url
    session.driver.network_traffic.each do |request|
      request.response_parts.uniq(&:url).each do |response|
        if (400..599).include?response.status
          puts "\n Error: Responce URL #{response.url}: \n Status #{response.status}"
        else
          puts "\n Info: Responce URL #{response.url}: \n Status #{response.status}"
        end
      end
    end
  end
end