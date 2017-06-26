# frozen_string_literal: true
require 'webRenovation/webRenovation_spec_helper'
require 'google_drive'

session = GoogleDrive::Session.from_config("config.json")
ws = session.spreadsheet_by_key("1sUEizFQYu1fc0kunEST-JpHWWH9vMWHr0lj1ZKiIWyk").worksheets[1]
ws_hash = {}
for i in 2..ws.num_rows do
  ws_hash[ws[i,2]] = ws[i,1]
end

feature 'User Browsing', js: true do
  scenario 'Load Homepage', :read_only, :smoke_test do
    hrefs = []
    ('a'..'z').each do |letter|
      visit "/databases/#{letter}"
      sleep(1)
      within('.container-fluid .content-area .row') do
        all('a').map { |a_tag| a_tag.base.attributes['href'] }.each do |href|
          hrefs.append(href)
        end
      end
    end
    missing_databases = ws_hash.keys - hrefs
    File.open("output/missing_databases.csv", "w+") do |f|
      missing_databases.each do |database|
        # puts url of the database into output file
        f.puts(database)
      end
    end
  end
end
