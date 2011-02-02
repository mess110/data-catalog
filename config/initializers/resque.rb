require 'resque'

require 'resque_scheduler'
ConfigFile.load('resque_schedule.yml') do |config|
  Resque.schedule = config
end
