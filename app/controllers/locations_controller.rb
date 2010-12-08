class LocationsController < ApplicationController

  def index
    @locations = Location.ascending(:name)
  end

  def show
    @location = Location.where(:uid => params[:id]).first
  end

  def new
  end

  def create
  end

end
