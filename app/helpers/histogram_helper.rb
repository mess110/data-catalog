module HistogramHelper

  BASE_URL = 'http://chart.apis.google.com/chart'
  DIMENSIONS = '135x90'

  def histogram_image_tag(data_set_id, field_name, image_options = {})
    filename = histogram_cached_filename(data_set_id, field_name)
    path = if File.exist?(filename) && CacheHistogram.fresh?(filename)
      histogram_cached_path(data_set_id, field_name)
    else
      Resque.enqueue(CacheHistogram, data_set_id, field_name)
      histogram_url(data_set_id, field_name)
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
  #    &cht=bhs
  #    &chco=0B6E8E
  #    &chds=0,16
  #    &chd=t:4,12,15,9,3
  def histogram_url(data_set_id, field_name)
    data_set = DataSet.criteria.id(data_set_id).first
    unless data_set
      raise "Could not find DataSet with id: #{data_set_id}"
    end
    values = data_set[field_name]['bins']
    values_max = round_up(values.max, 2)
    x_labels = values_max > 0 ? "|0|#{values_max / 2}|#{values_max}" : "|0"
    y_labels = "|poor|fair|average|good|excellent"
    font_size = "10.5"
    BASE_URL +
      "?chxl=0:#{x_labels}|1:#{y_labels}" +
      "&chxr=0,0,#{values_max}|1,1,5" +
      "&chxs=0,676767,#{font_size},0,l,676767|1,676767,#{font_size},0,l,676767" +
      '&chxt=x,y' +
      '&chbh=12,2,2' +
      "&chs=#{DIMENSIONS}" +
      '&cht=bhs' +
      '&chco=0B6E8E' +
      "&chds=0,#{values_max}" +
      "&chd=t:#{values.join(',')}"
  end

  def histogram_cached_path(data_set_id, field_name)
    '/images/data_set_ratings/' +
      histogram_basename(data_set_id, field_name)
  end

  def histogram_cached_filename(data_set_id, field_name)
    Rails.root.join('public/images/data_set_ratings',
      histogram_basename(data_set_id, field_name))
  end

  protected

  def round_up(value, multiple)
    (value / multiple.to_f).ceil * multiple
  end

  def histogram_basename(data_set_id, field_name)
    "#{data_set_id}-#{field_name}-#{DIMENSIONS}.png"
  end

end
