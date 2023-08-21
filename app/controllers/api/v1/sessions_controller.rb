class Api::V1::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      forwarding_url = session[:forwarding_url]
      reset_session
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      session[:session_token] = user.session_token
      redirect_to forwarding_url || api_v1_user_path(user.id), json: { user_id: user.id, message: 'Logged in successfully' }
    else
      render json: { error: 'Invalid email/password combination' }, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url

    render json: { message: 'Logged out successfully' }
  end
end
