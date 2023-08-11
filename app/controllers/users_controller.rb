class UsersController < ApplicationController
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
      redirect_to @user
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
