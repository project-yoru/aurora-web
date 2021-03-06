class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # def render_403
  #   raise ActionController::RoutingError.new('Forbidden')
  # end

  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end

  def after_sign_in_path_for(resource)
    projects_path || request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

end
