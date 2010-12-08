class CountCategories
  @queue = :queries

  FILENAME = Rails.root.join("tmp/query-cache/category_counts.yml")
  URL_HELPERS = Rails.application.routes.url_helpers

  def self.perform(limit)
    return if File.exist?(FILENAME) && fresh?
    category_counts = calculate_category_counts(limit)
    FileUtils.mkdir_p(File.dirname(FILENAME))
    File.open(FILENAME, 'w') do |file|
      YAML.dump(category_counts, file)
    end
    category_counts
  end

  def self.calculate_category_counts(limit)
    Category.ascending(:name).map { |category|
      {
        :path  => URL_HELPERS.category_path(category),
        :name  => category.name,
        :count => category.data_sources.count
      }
    }.select { |h| h[:count] > 0 }.sort_by { |h| -h[:count] }.take(limit)
  end

  def self.fresh?(threshold = 1.minute)
    Time.now - File.mtime(FILENAME) < threshold
  end

end
