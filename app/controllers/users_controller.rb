class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.where(:uid => params[:id]).first
  end

  def new
  end

  def create
  end

end
