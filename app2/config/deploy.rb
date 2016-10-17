# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'my_app_name'
set :repo_url, 'https://github.com/h-parekh/QA_tests.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/app/myTests'

# Default value for :scm is :git
set :scm, :git
set :branch, "master"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

#to ensure any needed password prompts from SSH show up in your terminal

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5, how many releases Capistrano should store on your server's harddrive
set :keep_releases, 5

#the user you want to use for your server's deploys
set :user, "app"

#use_sudo to false so commands are executed with the user's permissions unless I specify otherwise
set :use_sudo, false

set :rails_env, "testController"

#:remote_cache will run a fetch from your server to your remote repository and only update what's changed
#:copy This will clone your entire repository (download it from the remote to your local machine) and then upload the entire app to your server.
set :deploy_via, :copy

# deploy location, :primary => true part of the database role tells Capistrano that this is the location of your primary database
server "testcontroller01.library.nd.edu", user: 'app'
