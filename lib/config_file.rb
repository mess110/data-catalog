class ConfigFile

  def self.load(filename)
    pathname = Rails.root.join('config', filename)
    raise "Missing configuration file: #{pathname}" unless File.exist?(pathname)
    configs = YAML::load_file(pathname)
    config = configs[Rails.env]
    raise "No configuration for #{Rails.env} environment" unless config
    yield(config)
  end

end