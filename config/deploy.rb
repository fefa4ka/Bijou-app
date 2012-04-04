set :rvm_type, :user  # Copy the exact line. I really mean :user here

set :default_environment, {
  'PATH' => "/home/missings/.rvm/gems/ruby-1.9.3-p125@production:/home/missings/.rvm/gems/ruby-1.9.3-p125@global:$PATH",
  'RUBY_VERSION' => 'ruby 1.9.3',
  'GEM_HOME'     => '/home/missings/.rvm/gems/ruby-1.9.3-p125@production',
  'GEM_PATH'     => '/home/missings/.rvm/gems/ruby-1.9.3-p125@production',
  'BUNDLE_PATH'  => '/home/missings/.rvm/gems/ruby-1.9.3-p125@production'  # If you are using bundler.
}                 

after 'unicorn:stop', 'thinking_sphinx:stop'
after 'thinking_sphinx:stop', 'deploy:pipeline_precompile'
after 'deploy:pipeline_precompile', 'deploy:update_crontab'

namespace :deploy do
  desc 'Update the crontab file'
  task :update_crontab, :roles => :db do
    run "cd #{current_path} && bundle exec whenever --update-crontab #{application}"
  end
  task :pipeline_precompile do
    run "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
  end
end

namespace :deploy do
  desc "Create asset packages for production"
  task :after_update_code, :roles => [:web] do
    run <<-EOF
      cd #{release_path} && rake asset:packager:build_all
    EOF
  end
end

namespace :rvm do
  task :trust_rvmrc do
    run \"rvm rvmrc trust \#\{release_path\}\"
  end
end
