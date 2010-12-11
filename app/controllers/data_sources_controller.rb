class DataSourcesController < ApplicationController

  def index
    @data_sources = DataSource.top_level
  end

  def show
    @data_source = DataSource.where(:slug => params[:id]).first
    render_404 && return unless @data_source
  end

  def new
  end

  def create
  end

end
