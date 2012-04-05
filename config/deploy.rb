
after 'deploy:update', 'whenever:update_crontab'
after 'deploy:update', 'deploy:assets:precompile'
after 'deploy:restart', 'unicorn:stop'
after 'deploy:restart', 'thinking_sphinx:stop'

