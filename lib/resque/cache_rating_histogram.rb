class CacheRatingHistogram
  extend RatingHistogramHelper

  @queue = :rating_histogram

  def self.perform(data_set_id, field_name)
    filename = rating_histogram_cached_filename(data_set_id, field_name)
    return if File.exist?(filename) && fresh?(filename)
    url = rating_histogram_url(data_set_id, field_name)
    system %(curl "#{url}" -o #{filename} --create-dirs)
  end

  def self.fresh?(filename, threshold = 1.hour)
    Time.now - File.mtime(filename) < threshold
  end

end
