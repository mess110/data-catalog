class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_analytics

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protected

  def render_status(code)
    respond_to do |format|
      format.json do
        render :json => nil, :status => code, :layout => false
      end
      format.html do
        render "public/#{code}.html", :status => code, :layout => false
      end
    end
  end

  def set_analytics
    @analytics_key = DataCatalog::Application.config.analytics_key
  end

end
