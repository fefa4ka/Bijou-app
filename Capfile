$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.    
require 'thinking_sphinx/deploy/capistrano'

set :rvm_ruby_string, '1.9.3-p125@production'        # Or whatever env you want it to run in.
set :rvm_type, :user

require 'capistrano-deploy'
use_recipes :git, :rails, :bundle, :unicorn    

load 'deploy/assets'

server '89.222.212.14', :web, :app, :db, :primary => true
set :user, 'missings'
set :deploy_to, '/home/missings/application'
set :repository, 'git@github.com:fefa4ka/Bijou-app.git'

after 'deploy:update',  'bundle:install'
after 'deploy:restart', 'unicorn:stop'
after "deploy:update_code", "rvm:trust_rvmrc"

namespace :rvm do
  desc 'Trust rvmrc file'
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_release}"
  end
end     
