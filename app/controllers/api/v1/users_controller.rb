class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update]
  before_action :authenticate_request!, except: [:create]
  before_action :correct_user, only: [:update, :destroy]

  def show
    @user = User.find(params[:id])
    if @user.present?
      respond_to do |format|
        format.html.haml
        format.json { render json: @user, serializer: UserSerializer }
      end
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      #redirect_to api_v1_user_path(@user.id)
      render json: @user, serializer: UserSerializer, status: :created, message: 'User created successfully'
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: { message: 'Profile updated successfully', user: @user }
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    render json: { message: 'Your account has been deleted' }
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end

  def correct_user
    @user = User.find(params[:id])
    if !current_user?(@user)
      render json: { error: "You don't have permission to view this profile." }, status: :forbidden
    end
  end
end
