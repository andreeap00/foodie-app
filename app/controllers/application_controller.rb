class ApplicationController < ActionController::Base
  include ActionController::Helpers
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :null_session
  include AuthenticationService

  protect_from_forgery with: :exception
  layout :layout_by_resource

  # helper methods from AuthenticationService which are available to views
  helper_method :logged_in?, :current_user

  private

  def layout_by_resource
    if request.format == 'application/json'
      'api' 
    else
      'application' 
    end
  end

  def index
  end

  # as a before_action in controllers
  def authenticate_request!
    header = request.headers['Authorization']

    if header.present?
      token = header.split(' ').last
      payload = JwtService.decode(token)
      @current_user = User.find_by(id: payload[:user_id]) if payload
    end

    unless @current_user
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
