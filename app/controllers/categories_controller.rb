class CategoriesController < ApplicationController

  def index
    @categories = Category.ascending(:name)
  end

  def show
    @category = Category.where(:uid => params[:id]).first
  end

  def new
  end

  def create
  end

end
