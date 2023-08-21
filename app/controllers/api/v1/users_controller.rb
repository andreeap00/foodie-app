class Api::V1::UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :update, :destroy]
  before_action :correct_user, only: [:update, :destroy]

  def new
    @user = User.new
  end

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
      render json: { message: 'User created successfully', user: @user }, status: :created
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

    def logged_in_user
      if !logged_in?
        store_location
        #flash[:danger] = "Please log in."
        redirect_to api_v1_login_path
      end
    end
    
    # user can only update his/her profile 
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
