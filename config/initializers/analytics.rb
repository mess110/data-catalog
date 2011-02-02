ConfigFile.load('analytics.yml') do |config|
  DataCatalog::Application.config.analytics_key = config['key']
end
