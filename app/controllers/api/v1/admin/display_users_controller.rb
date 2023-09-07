class Api::V1::Admin::DisplayUsersController < Api::V1::ApplicationController
  include AdminAuthorization

  def index
    render json: User.where(role: :user), each_serializer: UserSerializer
  end
end
