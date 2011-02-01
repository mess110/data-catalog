class CacheRatingMeter
  extend RatingMeterHelper

  @queue = :rating_meter

  def self.perform(value)
    filename = rating_meter_cached_filename(value)
    return if File.exist?(filename) && fresh?(filename)
    url = rating_meter_url(value)
    system %(curl "#{url}" -o #{filename} --create-dirs)
  end

  def self.fresh?(filename, threshold = 1.hour)
    Time.now - File.mtime(filename) < threshold
  end

end
