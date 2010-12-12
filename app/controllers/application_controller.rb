class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_analytics

  protected

  def render_404
    render 'public/404.html', :status => 404, :layout => false
  end

  def set_analytics
    @analytics_key = DataCatalog::Application.config.analytics_key
  end

end
