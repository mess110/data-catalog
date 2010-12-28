class HomeController < ApplicationController

  def index
    @location_counts = CountDataSetsByLocation.perform(9)
    @category_counts = CountDataSetsByCategory.perform(9)
    @counts = {
      :data_set => DataSet.all.length,
      :site        => Site.all.length
    }
    @data_representation_counts = DataSet.data_representation_counts
    @featured_data_set = FeaturedDataSet.current
    @activities = Activity.recent(15)
  end

end
