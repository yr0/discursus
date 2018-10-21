set :output, 'log/whenever.log'

every 4.hours do
  rake 'sunspot:reindex'
end
