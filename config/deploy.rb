# frozen_string_literal: true
# config valid only for current version of Capistrano
lock '3.7.1'
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
set :branch hp_jenkins_trigger


desc "Run test against curate"
task :curate_test, :roles => :curate do
  echo "Running curate test"
end

desc "Run test against curate"
task :testapi_test, :roles => :testApi do
  echo "Running testapi test"
end
