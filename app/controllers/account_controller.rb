class AccountController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User.find(params[:id])
    render_404 && return unless @user
  end

  # To verify if a user is signed in, use the following helper:
  #   user_signed_in?
  # 
  # For the current signed-in user, this helper is available:
  #   current_user
  # 
  # You can access the session for this scope:
  #   user_session
  
end
