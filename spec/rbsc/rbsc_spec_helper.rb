require 'spec_helper'

app_name = 'rbsc'
config_file = app_name + '_config.yml'
trigger_file = app_name + '_trigger.yml'

cnf = YAML::load_file(File.expand_path("../" + app_name + "/" + config_file, __dir__))
trigger = YAML::load_file(File.expand_path("../" + app_name + "/" + trigger_file, __dir__))
target_env = trigger['target']

if target_env.nil? || target_env.to_s == ''
  target_env = ask("Enter target env, options are pprd or prod:  ") { |q| q.echo = true }
end

Capybara.app_host = cnf[target_env]
