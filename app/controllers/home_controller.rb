class HomeController < ApplicationController

  def index
    @counts = {
      :data_source => DataSource.all.length,
      :site        => Site.all.length
    }
    @data_representation_counts = DataSource.data_representation_counts
    @category_counts = calculate_category_counts(10)
  end

  protected

  def calculate_category_counts(limit = 10)
    filename = CountCategories::FILENAME
    unless File.exist?(filename) && CountCategories.fresh?
      CountCategories.perform(limit)
    end
    YAML.load_file(filename)
  end

end
