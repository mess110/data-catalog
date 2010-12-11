class CategoriesController < ApplicationController

  def index
    @categories = Category.primary.ascending(:name)
  end

  def show
    @category = Category.where(:uid => params[:id]).first
    render_404 && return unless @category
  end

  def new
  end

  def create
  end

end
