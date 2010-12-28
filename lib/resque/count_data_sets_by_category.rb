class CountDataSetsByCategory
  @queue = :queries

  FILENAME = Rails.root.join(
    "tmp/query-cache/data_sets_counted_by_category.yml")
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
    Category.all.map do |category|
      {
        :path  => URL_HELPERS.category_path(category),
        :name  => category.name,
        :count => category.data_sets.count
      }
    end.select { |h| h[:count] > 0 }.sort_by { |h| [-h[:count], h[:name]] }.
      take(limit)
  end

  def self.fresh?(threshold = 1.minute)
    Time.now - File.mtime(FILENAME) < threshold
  end

end
