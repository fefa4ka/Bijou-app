after 'deploy:update',  'bundle:install'

use_recipes :rails_assets, :whenever  
after 'deploy:update', 'whenever:update_crontab'
after 'deploy:restart', 'unicorn:stop'
after 'deploy:restart', 'thinking_sphinx:stop'

