class ApplicationController < ActionController::Base
  include SessionsHelper
  include ActionController::Helpers
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :null_session

  protect_from_forgery with: :exception
  layout :layout_by_resource

  private

  def layout_by_resource
    if request.format == 'application/json'
      'api' 
    else
      'application' 
    end
  end

  # used to render your main layout for HTML requests
  def index
  end
end
