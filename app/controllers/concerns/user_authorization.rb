module UserAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
    before_action :authorize_user
  end

  private
    
  def authorize_user
    render json: { error: "You are not authorized to access this page." }, status: :unauthorized if !current_user.user?
  end
end
