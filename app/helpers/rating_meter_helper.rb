module RatingMeterHelper

  BASE_URL   = 'http://chart.apis.google.com/chart'
  DIMENSIONS = '80x16'
  SUBFOLDER  = 'data_set_average_ratings'
  COLOR      = '0B6E8E'

  def rating_meter_image_tag(value, image_options = {})
    filename = rating_meter_cached_filename(value)
    path = if File.exist?(filename) && CacheRatingMeter.fresh?(filename)
      rating_meter_cached_path(value)
    else
      Resque.enqueue(CacheRatingMeter, value)
      rating_meter_url(value)
    end
    image_tag(path, { :alt => "%.1f of 5" % value, :size => DIMENSIONS }.
      merge(image_options))
  end

  # Horizontal Bar Chart
  def rating_meter_url(value)
    BASE_URL +
      "?chxr=0,0,5" +
      "&chxs=0,,0,0,_|1,,0,0,_" +
      "&chxt=x,y" +
      "&chbh=15,0,0" +
      "&chs=#{DIMENSIONS}" +
      "&cht=bhs" +
      "&chco=#{COLOR}" +
      "&chds=0,5" +
      "&chd=t:%.1f" % value +
      "&chg=20,100,1,0"
  end

  def rating_meter_cached_path(value)
    "/images/#{SUBFOLDER}/" + rating_meter_basename(value)
  end

  def rating_meter_cached_filename(value)
    Rails.root.join("public/images/#{SUBFOLDER}",
      rating_meter_basename(value))
  end

  protected

  def rating_meter_basename(value)
    "%.1f-#{DIMENSIONS}.png" % value
  end

end
