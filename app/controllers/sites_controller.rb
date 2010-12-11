class SitesController < ApplicationController

  def index
    @sites = Site.ascending(:name)
  end

  def show
    @site = Site.where(:uid => params[:id]).first
    render_404 && return unless @site
  end

  def new
  end

  def create
  end

end
