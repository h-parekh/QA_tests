# frozen_string_literal: true
require 'crawler/crawler_spec_helper'
require 'Nokogiri'
require "net/http"
require "uri"

File.foreach(ENV["HOME"]+"/crawl_sites.txt") do |url|
  url.delete!("\n")
  puts
  puts "Checking #{url}"
  puts
  encoded_url = URI.encode(url)
  doc = Nokogiri::HTML(open(encoded_url))
  root = url
  links = doc.css('a')
  hrefs = links.map {|link| link.attribute('href').to_s}.uniq.sort.delete_if {|href| href.empty?}
  for link in hrefs do
    if link.start_with?('/')
      link = root+link
    end
    if link.include? "#"|| link == " " || link =~ /mailto:(.*)/|| link.nil?

    else
      encoded_link = URI.encode(link)
      uri = URI.parse(link)
      begin
        response = Net::HTTP.get_response(uri)
        #puts "#{link} #{response.code}"
        if response.code == "404"

          #puts "Bad link #{link} on #{url}"
        end
      rescue SystemCallError
        puts "Connection failed on: #{link}"
        next
      end
    end
  end
end
