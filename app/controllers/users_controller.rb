class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    if @user.present?
      @purchased_orders = @user.orders
    else
      flash[:error] = "User not found."
      redirect_to login_path
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) 
    if @user.save
      reset_session
      log_in @user
      flash[:success] = "Welcome to the Food Universe!"
      if @user.admin?
        redirect_to admin_dashboard_path
      elsif @user.user?
        redirect_to user_path(@user)
      end
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.orders.where(user_id: @user.id).update_all(is_archived: true, user_id: nil)
    @user.destroy
    flash[:success] = "Your account has been deleted."
    redirect_to home_path
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    # user can only update his/her profile 
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
