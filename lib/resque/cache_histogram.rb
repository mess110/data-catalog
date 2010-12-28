class CacheHistogram
  extend HistogramHelper

  @queue = :histogram

  def self.perform(data_set_id, field_name)
    filename = histogram_cached_filename(data_set_id, field_name)
    return if File.exist?(filename) && fresh?(filename)
    url = histogram_url(data_set_id, field_name)
    system %(curl "#{url}" -o #{filename} --create-dirs)
  end

  def self.fresh?(filename, threshold = 1.hour)
    Time.now - File.mtime(filename) < threshold
  end

end
