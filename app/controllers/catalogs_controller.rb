class CatalogsController < ApplicationController

  def index
    @catalogs = Catalog.ascending(:name)
  end

  def show
    @catalog = Catalog.where(:uid => params[:id]).first
    render_404 && return unless @catalog
  end

  def new
  end

  def create
  end

end
