# frozen_string_literal: true

require 'crawler/crawler_spec_helper'
require 'nokogiri'
require "net/http"
require "uri"
require "set"
feature 'Link Checker' do
  scenario 'Check Links', :read_only do
    begin
      File.foreach(ENV["HOME"] + "/crawl_sites.txt") do |root_url|
        root_url.strip!
        current_logger.info(context: "Begin verifying site: #{root_url}")
        encoded_url = URI.encode(root_url)
        doc = Nokogiri::HTML(open(encoded_url))
        links = doc.css('a')
        hrefs = Set.new
        links.each do |link|
          href = link.attribute('href').to_s.strip
          hrefs << href unless href.empty?
        end
        hrefs.each do |href|
          href = root_url + href if href.start_with?('/')
          next if href =~ /\A#/ || href =~ /mailto:/ || href =~ /tel:/
          uri = URI.parse(href)
          http = Net::HTTP.new(uri.host, uri.port)
          http.read_timeout = 5
          http.open_timeout = 5
          http.use_ssl = true if uri.scheme == 'https'

          begin
            response = http.start do |block_http|
              block_http.get(uri)
            end
            if response.code.to_i >= 400 && response.code.to_i <= 599
              current_logger.info(context: "crawler ERROR", url: href, status_code: response.code)
            else
              current_logger.debug(context: "Verified link", url: href, status_code: response.code)
            end
          rescue Net::OpenTimeout
            current_logger.error(context: "Could not reach URL in specified time", url: href, timeout_in_sec: http.open_timeout)
          end
        end
        current_logger.info(context: "Finished verifying site: #{root_url}")
      end
    rescue Errno::ENOENT
      current_logger.error(context: "Expected input file", filename: ENV["HOME"] + "/crawl_sites.txt")
      current_logger.error(context: "Create a local file with list of sites to verify")
    end
  end
end
