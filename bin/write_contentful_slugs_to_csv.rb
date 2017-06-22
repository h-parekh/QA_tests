# frozen_string_literal: true
require 'contentful'
require 'yaml'

user_home_dir = File.expand_path('~')
# Accesses the file to get the jwt token
yaml = YAML.load_file(File.join("#{user_home_dir}", 'test_data/QA/cf_api_key.yml'))
qa = yaml.fetch('QA_key')
token = qa.fetch('cdn_token')
space = qa.fetch('space_id')

client = Contentful::Client.new(
  space: "#{space}",
  access_token: "#{token}",
)

pages = client.entries(
  'content_type' => 'page',
  'fields.slug[exists]' => true,
)
floors = client.entries(
  'content_type' => 'floor',
  'fields.slug[exists]' => true,
)

File.open("tmp/contentful_slugs.csv", "w+") do |f|
  pages.each do |entry|
    f.puts("#{entry.slug}, https://alpha.library.nd.edu/#{entry.slug}")
  end

  floors.each do |entry|
    f.puts("#{entry.slug}, https://alpha.library.nd.edu/#{entry.slug}")
  end
end
