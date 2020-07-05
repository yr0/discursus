# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'discursus'
set :repo_url, 'git@bitbucket.org:numberonename/discursus-rails.git'
set :keep_releases, 5
set :rvm_ruby_version, '2.4.9'

append :linked_files, 'config/database.yml', 'config/puma.rb', '.env'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'public/uploads'

namespace :discursus do
  desc 'Restart service'
  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, 'discursus.target'
    end
  end

  desc 'Reindex solr data'
  task :solr_reindex do
    on roles(:app) do
      within current_path do
        execute :bundle, :exec, :rails, 'sunspot:solr:reindex'
      end
    end
  end

  desc 'Create puma configuration in shared/config directory'
  task :load_puma_template do
    on roles(:app) do
      config = File.open(File.join(__dir__, *%w(templates puma.rb)), &:read)
      config.gsub!('$$project_dir', deploy_to)
      upload! StringIO.new(config), "#{shared_path}/config/puma.rb"
    end
  end
end
