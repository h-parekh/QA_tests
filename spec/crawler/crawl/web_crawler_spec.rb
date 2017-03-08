# frozen_string_literal: true
require 'crawler/crawler_spec_helper'
require 'Nokogiri'
require "net/http"
require "uri"
feature 'Link Checker' do
  scenario 'Check Links' do
    File.foreach(ENV["HOME"] + "/crawl_sites.txt") do |url|
      url.delete!("\n")
      current_logger.info(context: "Starting to verify: #{url}")
      encoded_url = URI.encode(url)
      doc = Nokogiri::HTML(open(encoded_url))
      root = url
      links = doc.css('a')
      hrefs = links.map { |link| link.attribute('href').to_s }.uniq.sort.delete_if { |href| href.empty? }
      for link in hrefs do
        if link.start_with?('/')
          link = root + link
        end
        if link.include?("#") || link == " " || link =~ /mailto:(.*)/ || link.nil?
        else
          uri = URI.parse(link)
          begin
            response = Net::HTTP.get_response(uri)
            if response.code.to_i >= 400 && response.code.to_i <= 599
              current_logger.info(context: "crawler", url: link, status_code: response.code)
            end
          # Captures known errors from links to mailto: and tel:
          # ex. mailto:email@nd.edu
          rescue SystemCallError
            current_logger.info(context: "Connection failed on: #{link}")
            next
          end
        end
      end
    end
  end
end
