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

after 'deploy:restart', 'deploy:pipeline_precompile'
after 'deploy:pipeline_precompile', 'deploy:update_crontab'

namespace :deploy do
  desc 'Update the crontab file'
  task :update_crontab, :roles => :db do
    run "cd #{current_path} && bundle exec whenever --update-crontab #{application}"
  end
end

namespace :deploy do
  task :pipeline_precompile do
    run "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
  end
  desc "Create asset packages for production"
  task :after_update_code, :roles => [:web] do
    run <<-EOF
      cd #{release_path} && rake asset:packager:build_all
    EOF
  end
end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end