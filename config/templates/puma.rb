#!/usr/bin/env puma

directory '$$project_dir/current'
rackup '$$project_dir/current/config.ru'
environment 'production'

pidfile '$$project_dir/shared/tmp/pids/puma.pid'
state_path '$$project_dir/shared/tmp/pids/puma.state'
stdout_redirect '$$project_dir/shared/log/puma_access.log',
                '$$project_dir/shared/log/puma_error.log', true

threads 1, 6

bind 'unix://$$project_dir/shared/tmp/sockets/puma.sock'

workers 1

prune_bundler

on_restart do
  ENV['BUNDLE_GEMFILE'] = '$$project_dir/current/Gemfile'
end
