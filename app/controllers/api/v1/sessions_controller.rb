class Api::V1::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      token = JwtService.encode(user_id: user.id)

      respond_to do |format|
        format.html.haml do
          log_in user
          flash[:success] = "Logged in successfully"
          redirect_to api_v1_user_path(user.id)
        end
        format.json do
          render json: {
            user: @user,
            token: token
            # redirect_url: api_v1_user_path(user)
          }, serializer: UserSerializer, status: :ok
        end
      end
    else
      respond_to do |format|
        format.html.haml do
          flash.now[:danger] = 'Invalid email/password combination'
          render 'new'
        end
        format.json do
          render json: { error: 'Invalid email/password combination' }, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    log_out
    render json: { message: 'Logged out successfully' }
  end
end
