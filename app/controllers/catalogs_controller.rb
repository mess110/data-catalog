class CatalogsController < ApplicationController

  def index
    @catalogs = Catalog.all
  end

  def show
    @catalog = Catalog.where(:uid => params[:id]).first
  end

  def new
  end

  def create
  end

end
