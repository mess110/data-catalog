module HistogramHelper

  BASE_URL = 'http://chart.apis.google.com/chart'
  DIMENSIONS = '135x90'

  def histogram_image_tag(data_source_id, field_name, image_options = {})
    filename = histogram_cached_filename(data_source_id, field_name)
    path = if File.exist?(filename) && CacheHistogram.fresh?(filename)
      histogram_cached_path(data_source_id, field_name)
    else
      Resque.enqueue(CacheHistogram, data_source_id, field_name)
      histogram_url(data_source_id, field_name)
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
  def histogram_url(data_source_id, field_name)
    data_source = DataSource.criteria.id(data_source_id).first
    unless data_source
      raise "Could not find DataSource with id: #{data_source_id}"
    end
    values = data_source[field_name]['bins']
    values_max = round_up(values.max, 2)
    BASE_URL +
      "?chxl=0:|0|#{values_max / 2}|#{values_max}|1:|poor|fair|average|good|excellent" +
      "&chxr=0,0,#{values_max}|1,1,5" +
      '&chxs=0,676767,10,0,l,676767|1,676767,10,0,l,676767' +
      '&chxt=x,y' +
      '&chbh=13,1,1' +
      "&chs=#{DIMENSIONS}" +
      '&cht=bhs' +
      '&chco=0B6E8E' +
      "&chds=0,#{values_max}" +
      "&chd=t:#{values.join(',')}"
  end

  def histogram_cached_path(data_source_id, field_name)
    '/images/data_source_ratings/' +
      histogram_basename(data_source_id, field_name)
  end

  def histogram_cached_filename(data_source_id, field_name)
    Rails.root.join('public/images/data_source_ratings',
      histogram_basename(data_source_id, field_name))
  end

  protected

  def round_up(value, multiple)
    (value / multiple.to_f).ceil * multiple
  end

  def histogram_basename(data_source_id, field_name)
    "#{data_source_id}-#{field_name}-#{DIMENSIONS}.png"
  end

end
