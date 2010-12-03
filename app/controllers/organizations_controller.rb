class OrganizationsController < ApplicationController

  def index
    @organizations = Organization.all
  end

  def show
    @organization = Organization.where(:slug => params[:id]).first
  end

  def new
  end

  def create
  end

end
