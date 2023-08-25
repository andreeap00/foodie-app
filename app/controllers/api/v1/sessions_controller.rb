class Api::V1::SessionsController < Api::V1::ApplicationController
  include Authentication
  skip_before_action :authenticate

  def new
    render json: { message: 'New session form' }
  end

  def destroy
    token = encode_token_with_expired_time
    puts "The Boss Token: #{token}"
    
    render json: { message: 'User Logged out' }
  end

  def create
    user = User.find_by(email: params[:email].downcase)

    if user&.authenticate(params[:password])
      token = encode_token(user.id)
      render json: { token: token }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  private

  def encode_token(user_id)
    payload = {
      user_id: user_id,
      exp: Time.now.to_i + 3600
    }
    token = JWT.encode(payload, ENV['JWT_SECRET_KEY'], 'HS256')
    puts "Generated Token: #{token}"
    token
  end

  def encode_token_with_expired_time
    payload = {
      user_id: nil,
      exp: Time.now.to_i - 4000
    }
    token = JWT.encode(payload, ENV['JWT_SECRET_KEY'], 'HS256')
    puts "Expired Token: #{token}"
    token
  end
end
