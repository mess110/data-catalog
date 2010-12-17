class DiscussionsController < ApplicationController

  def index
    @discussions = DataSourceComment.descending(:created_at)
  end

  def show
  end

  def new
  end

  def create
  end

end
