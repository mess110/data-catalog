class DiscussionsController < ApplicationController

  def index
    @discussions = DataSetComment.descending(:created_at)
  end

  def show
  end

  def new
  end

  def create
  end

end
