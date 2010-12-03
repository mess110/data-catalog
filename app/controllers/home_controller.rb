class HomeController < ApplicationController

  def index
    @counts = DataSource.data_representation_counts
    @counts[:data_source] = DataSource.all.length
    @counts[:site]        = Site.all.length
  end

end
