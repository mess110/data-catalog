class LocationsController < ApplicationController

  def index
    @locations = Location.ascending(:name)
  end

  def show
    @location = Location.where(:uid => params[:id]).first
    render_404 && return unless @location
  end

  def new
  end

  def create
  end

end
