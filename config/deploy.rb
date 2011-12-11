set :rvm_type, :user  # Copy the exact line. I really mean :user here

set :default_environment, {
  'PATH' => "/usr/local/rvm/gems/ruby-1.9.3-p0@yapropal_production:/usr/local/rvm/gems/ruby-1.9.3-p0@global:$PATH",
  'RUBY_VERSION' => 'ruby 1.9.3',
  'GEM_HOME'     => '/usr/local/rvm/gems/ruby-1.9.3-p0@yapropal_production',
  'GEM_PATH'     => '/usr/local/rvm/gems/ruby-1.9.3-p0@yapropal_production',
  'BUNDLE_PATH'  => '/usr/local/rvm/gems/ruby-1.9.3-p0@yapropal_production'  # If you are using bundler.
}                 

namespace :rvm do
  task :trust_rvmrc do
    run \"rvm rvmrc trust \#\{release_path\}\"
  end
end