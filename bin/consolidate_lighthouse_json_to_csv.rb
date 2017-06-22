# Consolidate lighthouse output into a single CSV
#
# @see ./bin/run_lighthouse_against_urls_and_generate_csv.rb
require 'csv'
require 'fileutils'
require 'pathname'
require 'json'

PROJECT_PATH = Pathname.new(File.expand_path('../../', __FILE__))
INPUT_PATH = PROJECT_PATH.join('tmp/web-rennovation-accessibility-json')
REPORT_CATEGORIES_TO_TEST = ["Accessibility", "Best Practices"]
DATE_SUFFIX = Time.now.strftime('--on-%Y-%m-%d-at-%H-%M')
CSV.open(PROJECT_PATH.join("tmp/accessibility#{DATE_SUFFIX}.csv"), 'w+') do |csv|
  csv << ["URL", "CATEGORY_NAME", "AUDIT_ID", "AUDIT_HELP", "NOTE", "SELECTOR"]
  Dir.glob(INPUT_PATH.join("**/*.json")).each do |filename|
    json = JSON.parse(File.read(filename))
    url = json.fetch('initialUrl')
    json.fetch('reportCategories').each do |report_category|
      category_name = report_category.fetch('name')
      next unless REPORT_CATEGORIES_TO_TEST.include?(category_name)
      next if report_category.fetch("score") >= 100
      report_category.fetch("audits").each do |audit|
        next if audit.fetch('score') >= 100
        audit_id = audit.fetch('id').strip
        audit_result = audit.fetch('result')
        audit_help = audit_result.fetch('helpText')
        if audit_result.key?('details')
          [audit_result.fetch('details').fetch('items')].flatten.compact.each do |failing_item|
            failing_type = failing_item.fetch('type')
            selector = failing_item.fetch('selector', nil)
            case failing_type
            when 'node'
              snippet = failing_item.fetch('snippet')
              csv << [url, category_name, audit_id, audit_help, snippet, selector]
            when 'url'
              url = failing_item.fetch('text')
              csv << [url, category_name, audit_id, audit_help, url, selector]
            when 'text'
              next # Skipping http/1.1 and _blank
            end
          end
        else
          csv << [url, category_name, audit_id, audit_help, nil, nil]
        end
      end
    end
  end
end
