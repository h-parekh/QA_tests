# frozen_string_literal: true

require 'csv'
require 'fileutils'
require 'pathname'
require 'json'

namespace :webRennovation do
  desc "Query Contentful for data, run Lighthouse, and Build Report (WARNING: SLOW)"
  task(accessibility_audit: [
         "accessibility_audit:write_contentful_slugs_to_csv",
         "accessibility_audit:run_lighthouse_against_urls_and_generate_csv",
         "accessibility_audit:consolidate_lighthouse_json_to_csv"
       ])

  namespace :accessibility_audit do
    desc 'Check that the Lighthouse command is installed and the proper version'
    task :check_lighthouse do
      EXPECTED_LIGHTHOUSE_MAJOR_VERSION = "2"
      require 'open3'
      begin
        _stdin, stdout, _stderr, _wait_thr = Open3.popen3('lighthouse', '--version')
        version = stdout.read.strip
        major_version = version.split('.').first
        if major_version != EXPECTED_LIGHTHOUSE_MAJOR_VERSION
          warn "Expected lighthouse major version to be #{EXPECTED_LIGHTHOUSE_MAJOR_VERSION}, got #{major_version}"
          exit(1)
        end
      rescue Errno::ENOENT
        warn "Unable to find lighthouse command in your $PATH"
        warn "See https://github.com/GoogleChrome/lighthouse for details on installation"
        exit(2)
      end
    end
    desc 'Configuration variables'
    task :config do
      WEB_RENNOVATION_URL = "https://alpha.library.nd.edu"
      PROJECT_PATH = Pathname.new(File.expand_path(__dir__))
      PATH_FOR_JSON_REPORTS = PROJECT_PATH.join('tmp/web-rennovation-accessibility-json')
      DATE_SUFFIX = Time.now.strftime('--on-%Y-%m-%d-at-%H-%M')
      CONTENTFUL_CSV_FILENAME = PROJECT_PATH.join("tmp/contentful_slugs.csv").to_s
      FileUtils.mkdir_p(PROJECT_PATH.join('tmp'))
    end

    desc "Query contentful for all slugs that are accessible on the site"
    task write_contentful_slugs_to_csv: :config do
      require 'contentful'
      require 'yaml'

      # Accesses the file to get the jwt token
      yaml = YAML.load_file(File.join(ENV.fetch('HOME'), 'test_data/QA/cf_api_key.yml'))
      qa = yaml.fetch('QA_key')
      token = qa.fetch('cdn_token')
      space = qa.fetch('space_id')

      client = Contentful::Client.new(
        space: space.to_s,
        access_token: token.to_s
      )

      # Only content types with a slug have are addressable
      CSV.open(CONTENTFUL_CSV_FILENAME, "w+") do |csv|
        csv << ['SLUG', 'URL']
        client.content_types.each do |content_type|
          next unless content_type.fields.map(&:id).include?('slug')

          dirname = begin
            case content_type.id
            when /^floor$/i
              "floor/"
            else
              ""
            end
          end
          client.entries(
            'content_type' => content_type.id,
            'fields.slug[exists]' => true
          ).each do |entry|
            slug = File.join(dirname, entry.slug)
            csv << [slug, File.join(WEB_RENNOVATION_URL, slug)]
          end
        end
      end
    end

    desc "Run Lighthouse tests against the given URLs from Contentful (WARNING: VERY SLOW RUNNING)"
    task run_lighthouse_against_urls_and_generate_csv: [:config, :check_lighthouse] do
      FileUtils.mkdir_p(PATH_FOR_JSON_REPORTS) unless PATH_FOR_JSON_REPORTS.exist?
      FileUtils.rm_rf(PATH_FOR_JSON_REPORTS.join('*.json'))
      csv = CSV.read(CONTENTFUL_CSV_FILENAME, headers: true)
      csv.each do |line|
        url = line['URL'].strip
        slug = line['SLUG'].strip.tr('/', '-')
        system("lighthouse #{url} --output-path=#{PATH_FOR_JSON_REPORTS.join("#{slug}-#{DATE_SUFFIX}.json --output=json")}")
      end
    end

    desc "Consolidate Lighthouse JSON output into CSV"
    task consolidate_lighthouse_json_to_csv: :config do
      REPORT_CATEGORIES_TO_TEST = ["Accessibility", "Best Practices"].freeze
      CSV.open(PROJECT_PATH.join("tmp/accessibility-#{DATE_SUFFIX}.csv"), 'w+') do |csv|
        csv << ["URL", "CATEGORY_NAME", "AUDIT_ID", "AUDIT_HELP", "NOTE", "SELECTOR"]
        Dir.glob(PATH_FOR_JSON_REPORTS.join("**/*.json")).each do |filename|
          json = JSON.parse(File.read(filename))
          url = json.fetch('initialUrl')
          json.fetch('reportCategories').each do |report_category|
            category_name = report_category.fetch('name')
            next unless REPORT_CATEGORIES_TO_TEST.include?(category_name)
            # A Short circuit because there won't be any meaningful failures in this category
            # NOTE: We are storing the JSON documents locally with the full output
            next if report_category.fetch("score") >= 100

            report_category.fetch("audits").each do |audit|
              # A Short circuit because there won't be any meaningful failures
              # NOTE: We are storing the JSON documents locally with the full output
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
    end
  end
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new do |task|
  task.options = ['--display-cop-names']
end

task default: :rubocop
