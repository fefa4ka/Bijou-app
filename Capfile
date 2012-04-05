require 'capistrano-deploy'
require 'thinking_sphinx/deploy/capistrano'

Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

load 'config/deploy'


$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.    
set :rvm_ruby_string, '1.9.3-p125@production'        # Or whatever env you want it to run in.
set :rvm_type, :user

use_recipes :git, :rails, :bundle, :unicorn, :rails_assets, :whenever    

server '89.222.212.14', :web, :app, :db, :primary => true
set :user, 'missings'
set :deploy_to, '/home/missings/application'
set :repository, 'git@github.com:fefa4ka/Bijou-app.git'

set :release_path, '/home/missings/application'
set :current_path, '/home/missings/application'

after 'deploy:update',  'bundle:install'
