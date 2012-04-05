
after 'deploy:update', 'whenever:update_crontab'
after 'deploy:restart', 'unicorn:stop'
after 'deploy:restart', 'thinking_sphinx:stop'

