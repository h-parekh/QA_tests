# frozen_string_literal: true

require "English"
# config valid only for current version of Capistrano
lock '3.8.2'
#############################################################
#  Settings
#############################################################
set :application, 'QA_tests'
set :repo_url, 'git@github.com:ndlib/QA_tests.git'
set :deploy_to, '/home/app/QA_tests'
set :keep_releases, 5
set :deploy_via, :copy
set :stages, ["staging", "production"]
set :default_stage, "production"
set :branch, 'master'
set :tested_applications, ['bendo', 'buzz', 'classes', 'contentful', 'crawler', 'curate', 'curatebatchingestor', 'dave', 'dec', 'gatekeeper', 'hathitrust', 'hesburghsite', 'honeycomb', 'inquisition', 'microfilms', 'monarchlibguides', 'osf', 'primo', 'rbsc', 'recommendationengine', 'remix', 'seaside', 'sipity', 'solr', 'usurper', 'usurpercontent', 'vatican', 'viceroy', 'xur']
set :target_env_for_test_application, ENV['TARGET']
set :log_level_for_running_test, ENV['LOG_LEVEL']

# This task runs test against the test_application passed in as a ENV variable
# from the command line. Should match the folder name under spec directory in QA_tests
# Ensure they're listed in
#  - :tested_applications
#  - server roles in deploy/production.rb
# Sample Jenkins command: TARGET=prod LOG_LEVEL=info ROLES=curate cap production deploy
task :run_test do
  fetch(:tested_applications).each do |test_application|
    on roles(test_application) do
      if ENV['ROLES'] =~ /[^\w]?#{test_application}[^\w]?/
        info "Starting tests for #{test_application}"
        info `ENVIRONMENT=#{fetch(:target_env_for_test_application)} LOG_LEVEL=#{fetch(:log_level_for_running_test)} bundle exec rspec spec/#{test_application}`
        status = $CHILD_STATUS.exitstatus
        info "Finished cap run_task for #{test_application}"
        exit(status)
      end
    end
  end
end
