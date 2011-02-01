class OrganizationsController < ApplicationController

  autocomplete :organization, :name, :full => true

  def index
    @organizations = Organization.all
  end

  def show
    @organization = Organization.where(:slug => params[:id]).first
    render_404 && return unless @organization
  end

  def new
  end

  def create
  end

end
