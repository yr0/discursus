# frozen_string_literal: true

set :output, 'log/whenever.log'

every 30.minutes do
  rake 'sunspot:reindex'
end

every 1.day, at: '8am' do
  rake 'count_hlyna_downloads'
end
