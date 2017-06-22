# Generate a series of JSON files based on Lighthouse audits.
#
# @see https://github.com/GoogleChrome/lighthouse for instructions on installing the lighthouse script
# @see ./bin/consolidate_lighthouse_json_to_csv.rb

require 'csv'
require 'fileutils'
require 'pathname'
require 'time'

PROJECT_PATH = Pathname.new(File.expand_path('../../', __FILE__))
DATE_SUFFIX = Time.now.strftime('--on-%Y-%m-%d-at-%H-%M')
OUTPUT_PATH = PROJECT_PATH.join('tmp/web-rennovation-accessibility-json')

FileUtils.mkdir_p(OUTPUT_PATH) unless OUTPUT_PATH.exist?

csv = CSV.read(PROJECT_PATH.join('tmp/contentful_slugs.csv'))

csv.each do |line|
  url = line[1].strip
  slug = line[0].strip
  system("lighthouse #{url} --output-path=#{OUTPUT_PATH.join("#{slug}-#{DATE_SUFFIX}.json --output=json")}")
end
