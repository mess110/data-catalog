# encoding: UTF-8
module RatingHistogramHelper

  BASE_URL = 'http://chart.apis.google.com/chart'
  DIMENSIONS = '165x110'
  SUBFOLDER = 'data_set_rating_histograms'
  COLOR = '0B6E8E'

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

  # Horizontal Bar Chart:
  # http://chart.apis.google.com/chart
  #    ?chxl=0:|0|8|16|1:|poor|fair|average|good|excellent
  #    ?chxl=1:|poor|fair|average|good|excellent
  #    &chxr=0,0,16|1,1,5
  #    &chxs=0,676767,10,0,l,676767|1,676767,10,0,l,676767
  #    &chxt=x,y
  #    &chbh=13,1,1
  #    &chs=135x90
  #    &cht=bvs
  #    &chco=0B6E8E
  #    &chds=0,16
  #    &chd=t:4,12,15,9,3
  def rating_histogram_url(data_set_id, field_name)
    data_set = DataSet.criteria.id(data_set_id).first
    unless data_set
      raise "Could not find DataSet with id: #{data_set_id}"
    end
    values = data_set[field_name]['bins']
    values_max = round_up(values.max, 2)
    x_labels = "|1*|2*|3*|4*|5*" # "|poor|fair|average|good|excellent"
    y_labels = values_max > 0 ? "|0|#{values_max / 2}|#{values_max}" : "|0"
    label_color = "202020"
    font_size = "12"
    BASE_URL +
      "?chxl=0:#{x_labels}|1:#{y_labels}" +
      "&chxr=0,1,5|1,#{values_max}" +
      "&chxs=0,#{label_color},#{font_size},0,l|1,#{label_color},#{font_size},0,l" +
      "&chxt=x,y" +
      "&chbh=a" +
      "&chs=#{DIMENSIONS}" +
      "&cht=bvs" +
      "&chco=#{COLOR}" +
      "&chds=0,#{values_max}" +
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
