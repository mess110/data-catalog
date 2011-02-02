class CacheRatingMeter
  extend RatingMeterHelper

  @queue = :rating_meter

  def self.perform(value, confidence)
    filename = rating_meter_cached_filename(value, confidence)
    return if File.exist?(filename) && fresh?(filename)
    url = rating_meter_url(value, confidence)
    system %(curl "#{url}" -o #{filename} --create-dirs)
  end

  def self.fresh?(filename, threshold = 1.hour)
    Time.now - File.mtime(filename) < threshold
  end

end
