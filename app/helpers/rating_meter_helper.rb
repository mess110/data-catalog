module RatingMeterHelper

  BASE_URL   = 'http://chart.apis.google.com/chart'
  WIDTH      = 80
  MAX_HEIGHT = 16
  DIMENSIONS = "#{WIDTH}x#{MAX_HEIGHT}"
  SUBFOLDER  = 'data_set_average_ratings'
  COLOR      = '0B6E8E'

  def rating_meter_image_tag(average, count, image_options = {})
    confidence = calculate_confidence(count)
    filename = rating_meter_cached_filename(average, confidence)
    path = if File.exist?(filename) && CacheRatingMeter.fresh?(filename)
      rating_meter_cached_path(average, confidence)
    else
      Resque.enqueue(CacheRatingMeter, average, count)
      rating_meter_url(average, confidence)
    end
    image_tag(path, { :alt => "%.1f of 5" % average, :size => DIMENSIONS }.
      merge(image_options))
  end

  # Horizontal Bar Chart
  def rating_meter_url(average, confidence)
    height = calculate_height(confidence)
    bottom_margin = (MAX_HEIGHT - height) / 2
    BASE_URL +
      "?chxr=0,0,5" +
      "&chxs=0,,0,0,_|1,,0,0,_" +
      "&chxt=x,y" +
      "&chbh=%i,0,0" % height +
      "&chs=%s" % DIMENSIONS +
      "&chma=0,0,0,%i" % bottom_margin +
      "&cht=bhs" +
      "&chco=%s" % COLOR +
      "&chds=0,5" +
      "&chd=t:%.1f" % average +
      "&chg=20,100,1,0"
  end

  def rating_meter_cached_path(average, confidence)
    "/images/#{SUBFOLDER}/" + rating_meter_basename(average, confidence)
  end

  def rating_meter_cached_filename(average, confidence)
    Rails.root.join("public/images/#{SUBFOLDER}",
      rating_meter_basename(average, confidence))
  end

  protected

  def calculate_confidence(count)
    if    count >= 10 then 5
    elsif count >= 7  then 4
    elsif count >= 5  then 3
    elsif count >= 3  then 2
    elsif count >= 1  then 1
    else  raise "count must be > 0"
    end
  end

  # Confidence expected to be 1, 2, 3, 4, or 5
  # 
  # Returns value will always be odd, that way the resulting image will be
  # even, ensuring that vertical centering looks good for various heights.
  def calculate_height(confidence)
    confidence / 5.0 * (MAX_HEIGHT-1)
  end

  def rating_meter_basename(average, confidence)
    height = calculate_height(confidence)
    "%.1f-%i-%s.png" % [average, confidence, DIMENSIONS]
  end

end
