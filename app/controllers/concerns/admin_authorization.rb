module AdminAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
    before_action :authorize_admin
  end

  private
    
  def authorize_admin
    render json: { error: "You are not authorized to access this page." }, status: :unauthorized if !current_user.admin?
  end
end
