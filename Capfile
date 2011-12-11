$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.2@yapropal_production'        # Or whatever env you want it to run in.

require 'capistrano-deploy'
use_recipes :git, :rails, :bundle, :unicorn

server 'yapropal.ru', :web, :app, :db, :primary => true
set :user, 'production'
set :deploy_to, '/home/production/app'
set :repository, 'git@github.com:fefa4ka/Bijou-app.git'

after 'deploy:update',  'bundle:install'
after 'deploy:restart', 'unicorn:stop'
