class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.where(:uid => params[:id]).first
    @activities = @user.activities_as_subject.descending(:created_at)
  end

  def new
  end

  def create
  end

end
