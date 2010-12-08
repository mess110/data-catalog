class HomeController < ApplicationController

  def index
    @location_counts = CountDataSourcesByLocation.perform(10)
    @category_counts = CountDataSourcesByCategory.perform(10)
    @counts = {
      :data_source => DataSource.all.length,
      :site        => Site.all.length
    }
    @data_representation_counts = DataSource.data_representation_counts
  end

end
