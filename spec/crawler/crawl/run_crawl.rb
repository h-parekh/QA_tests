# frozen_string_literal: true
require 'crawler/crawler_spec_helper'
require 'Nokogiri'
require "net/http"
require "uri"

File.foreach(ENV["HOME"]+"/crawl_sites.txt") do |url|
  url.delete!("\n")
  encoded_url = URI.encode(url)
  doc = Nokogiri::HTML(open(encoded_url))
  root = url
  links = doc.css('a')
  hrefs = links.map {|link| link.attribute('href').to_s}.uniq.sort.delete_if {|href| href.empty?}
  for link in hrefs do
    puts link
    if link.start_with?('/')
      link = root+link
    end
    if link.include? "#"|| link == " " || link.start_with?("mailto")

    else
      encoded_link = URI.encode(link)
      uri = URI.parse(link)
      response = Net::HTTP.get_response(uri)
      puts "#{link} #{response.code}"
    end
  end
end
#feature 'User Browsing', js: true do
#  scenario "Test Links" do
#    page.driver.browser.js_errors = false
#    visit '/'
#    for link in page.all('a') do
#      print "#{link['href']}"
#      visit link['href']
#      puts status_code
#      visit Capybara.app_host
#    end
    #File.foreach(ENV["HOME"]+"/crawl_sites.txt") do |line|
    #  visit line
    #end
