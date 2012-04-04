set :rvm_type, :user  # Copy the exact line. I really mean :user here

set :default_environment, {
  'PATH' => "/home/missings/.rvm/gems/ruby-1.9.3-p125@production:/home/missings/.rvm/gems/ruby-1.9.3-p125@global:$PATH",
  'RUBY_VERSION' => 'ruby 1.9.3',
  'GEM_HOME'     => '/home/missings/.rvm/gems/ruby-1.9.3-p125@production',
  'GEM_PATH'     => '/home/missings/.rvm/gems/ruby-1.9.3-p125@production',
  'BUNDLE_PATH'  => '/home/missings/.rvm/gems/ruby-1.9.3-p125@production'  # If you are using bundler.
}                 


