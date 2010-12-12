require 'resque'

require 'resque_scheduler'
Resque.schedule = YAML.load_file(Rails.root.join(
  'config/initializers/resque_schedule.yml').to_s)
