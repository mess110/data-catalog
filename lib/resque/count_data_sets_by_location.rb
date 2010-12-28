class CountDataSetsByLocation
  @queue = :queries

  FILENAME = Rails.root.join(
    "tmp/query-cache/data_sets_counted_by_location.yml")
  URL_HELPERS = Rails.application.routes.url_helpers

  def self.perform(limit = 10)
    if File.exist?(FILENAME) && fresh?
      YAML.load_file(FILENAME)
    else
      counts = calculate_counts(limit)
      FileUtils.mkdir_p(File.dirname(FILENAME))
      File.open(FILENAME, 'w') { |file| YAML.dump(counts, file) }
      counts
    end
  end

  def self.calculate_counts(limit)
    counts = {}
    DataSet.all.each do |data_set|
      location = data_set.organization.location
      counts[location] ||= 0
      counts[location] += 1
    end
    counts.map do |location, count|
      {
        :path  => URL_HELPERS.location_path(location),
        :name  => location.name,
        :count => count
      }
    end.select { |h| h[:count] > 0 }.sort_by { |h| [-h[:count], h[:name]] }.
      take(limit)
  end

  def self.fresh?(threshold = 1.minute)
    Time.now - File.mtime(FILENAME) < threshold
  end

end