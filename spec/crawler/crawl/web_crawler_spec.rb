# frozen_string_literal: true
require 'crawler/crawler_spec_helper'
require 'Nokogiri'
require "net/http"
require "uri"
require "set"
feature 'Link Checker' do
  scenario 'Check Links' do
    File.foreach(ENV["HOME"] + "/crawl_sites.txt") do |root_url|
      root_url.strip!
      current_logger.info(context: "Begin verifying: #{root_url}")
      encoded_url = URI.encode(root_url)
      doc = Nokogiri::HTML(open(encoded_url))
      links = doc.css('a')
      hrefs = Set.new
      links.each do |link|
        href = link.attribute('href').to_s.strip
        hrefs << href unless href.empty?
      end
      for href in hrefs do
        if href.start_with?('/')
          href = root_url + href
        end
        next if href =~ /\A#/ || href =~ /mailto:/ || href =~ /tel:/
        uri = URI.parse(href)
        response = Net::HTTP.get_response(uri)
        if response.code.to_i >= 400 && response.code.to_i <= 599
          current_logger.info(context: "crawler ERROR", url: href, status_code: response.code)
        else
          current_logger.info(context: "Verified link", url: href, status_code: response.code)
        end
      end
      current_logger.info(context: "Finished verifying: #{root_url}")
    end
  end
end
