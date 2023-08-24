require 'dotenv'
Dotenv.load
class Api::V1::UsersController < Api::V1::ApplicationController
  include Authentication
  
  before_action :authenticate, only: [:show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  # def new
  #   @user = User.new
  #   render json: @user, serializer: UserSerializer
  # end

  def show
    @user = User.find(params[:id])
    render json: @user, serializer: UserSerializer
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, serializer: UserSerializer
    else
      Rails.logger.error(@user.errors.full_messages.join(', '))
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
    render json: @user, serializer: UserSerializer
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      render json: @user, serializer: UserSerializer
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation, :role)
    # params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end

  def correct_user
    @user = User.find(params[:id])
    render json: { error: 'Unauthorized' }, status: :unauthorized if !current_user?(@user)
  end
end
