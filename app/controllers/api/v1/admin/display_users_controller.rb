class Api::V1::Admin::DisplayUsersController < Api::V1::ApplicationController
  include AdminAuthorization

  def index
    @users = User.where(role: :user)
    render json: @users, each_serializer: UserSerializer
  end
end
