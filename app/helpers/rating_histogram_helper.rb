module RatingHistogramHelper

  BASE_URL = 'http://chart.apis.google.com/chart'
  DIMENSIONS = '165x110'
  SUBFOLDER = 'data_set_rating_histograms'
  COLOR = '0B6E8E'
  X_LABELS = "|1*|2*|3*|4*|5*" # "|poor|fair|average|good|excellent"
  FONT_SIZE = 12
  LABEL_COLOR = '202020'

  def rating_histogram_image_tag(data_set_id, field_name, image_options = {})
    filename = rating_histogram_cached_filename(data_set_id, field_name)
    path = if File.exist?(filename) && CacheRatingHistogram.fresh?(filename)
      rating_histogram_cached_path(data_set_id, field_name)
    else
      Resque.enqueue(CacheRatingHistogram, data_set_id, field_name)
      rating_histogram_url(data_set_id, field_name)
    end
    image_tag(path, { :alt => field_name, :size => DIMENSIONS }.
      merge(image_options))
  end

  # Horizontal Bar Chart
  def rating_histogram_url(data_set_id, field_name)
    data_set = DataSet.criteria.id(data_set_id).first
    raise "Could not find DataSet with id: #{data_set_id}" unless data_set
    values = data_set[field_name]['bins']
    max_value = round_up(values.max, 2)
    y_labels = max_value > 0 ? "|0|#{max_value / 2}|#{max_value}" : "|0"
    label_color = ""
    BASE_URL +
      "?chxl=0:#{X_LABELS}|1:#{y_labels}" +
      "&chxr=0,1,5|1,#{max_value}" +
      "&chxs=0,#{LABEL_COLOR},#{FONT_SIZE},0,l|1,#{LABEL_COLOR},#{FONT_SIZE},0,l" +
      "&chxt=x,y" +
      "&chbh=a" +
      "&chs=#{DIMENSIONS}" +
      "&cht=bvs" +
      "&chco=#{COLOR}" +
      "&chds=0,#{max_value}" +
      "&chd=t:#{values.join(',')}"
  end

  def rating_histogram_cached_path(data_set_id, field_name)
    "/images/#{SUBFOLDER}/" +
      rating_histogram_basename(data_set_id, field_name)
  end

  def rating_histogram_cached_filename(data_set_id, field_name)
    Rails.root.join("public/images/#{SUBFOLDER}",
      rating_histogram_basename(data_set_id, field_name))
  end

  protected

  def round_up(value, multiple)
    (value / multiple.to_f).ceil * multiple
  end

  def rating_histogram_basename(data_set_id, field_name)
    "#{data_set_id}-#{field_name}-#{DIMENSIONS}.png"
  end

end
