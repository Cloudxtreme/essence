require 'bundler/capistrano'
require 'capistrano-rbenv'
require './config/boot'

set :rbenv_ruby_version, '2.0.0-p247'
set :rbenv_install_dependencies, false

set :application, 'essence'
set :deploy_to, '/var/lib/rails/essence'
set :scm, :git
set :repository, 'git@github.com:kaethorn/essence.git'
set :deploy_via, :remote_cache
set :default_run_options, { :pty => true }
set :ssh_options, {:forward_agent => true}

set :user, 'passenger'
set :use_sudo, false

set :keep_releases, 5
after 'deploy:update', 'deploy:cleanup'

role :web, 'alphagemini.org'                          # Your HTTP server, Apache/etc
role :app, 'alphagemini.org'                          # This may be the same as your `Web` server
#role :db,  'alphagemini.org', :primary => true        # This is where Rails migrations will run

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
