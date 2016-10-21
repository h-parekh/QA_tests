# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'QA_tests'
set :repo_url, 'https://github.com/h-parekh/QA_tests.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

#Set the user you want to use for your server's deploys
set :user, 'app'
server 'testcontroller01.library.nd.edu'
# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/app/QA_tests'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5, specify how many releases Capistrano should store on your server's harddrive
set :keep_releases, 5

# set this to 'copy' will clone your entire repository (download it from the remote to your local machine) and then upload the entire app to your server. a faster method like remote_cache which will run a fetch from your server to your remote repository and only update what's changed
set :deploy_via, :copy

set :rails_env, 'production'

set :use_sudo, false
