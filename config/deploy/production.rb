server '159.69.147.170', roles: %w(app web db), primary: true, user: 'deploy'

set :deploy_to, '/home/deploy/discursus'
set :rails_env, 'production'

after 'deploy:finished', 'discursus:restart'
