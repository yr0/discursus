# frozen_string_literal: true

set :output, 'log/whenever.log'

every 4.hours do
  rake 'sunspot:reindex'
end

every 1.day, at: '11:15 pm' do
  command 'sudo cp /var/log/nginx/discursus_access.log.1 /home/deploy/discursus/shared/tmp/'
  command 'sudo chown deploy:deploy /home/deploy/discursus/shared/tmp/discursus_access.log.1'
  rake 'count_hlyna_downloads'
  command 'rm /home/deploy/discursus/shared/tmp/discursus_access.log.1'
end
