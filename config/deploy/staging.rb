server '94.130.73.140', roles: %w(app web db), primary: true, user: 'deploy'

set :deploy_to, '/home/deploy/discursus'
set :branch, :dev
set :rails_env, 'production'

after 'deploy:finished', 'discursus:restart'