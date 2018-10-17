set :output, File.join(File.dirname(__FILE__), '..', 'log', 'whenever.log')

every 1.day, at: '4am' do
  rake 'sunspot:reindex'
end
