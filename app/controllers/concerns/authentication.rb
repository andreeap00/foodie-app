module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

  def current_user
    return @current_user
  end

  private

  def authenticate
    jwt_secret_key = ENV['JWT_SECRET_KEY']
    token = bearer_token

    if token
      puts "Token found: #{token}"
      begin
        decoded_token = JWT.decode(token, ENV['JWT_SECRET_KEY'], true, algorithm: 'HS256')
        user_id = decoded_token.first['user_id']
        @current_user = User.find(user_id)
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { error: 'Token missing' }, status: :unauthorized
    end
  end

  def bearer_token
    pattern = /^Bearer /
    header = request.headers['Authorization']
    header.gsub(pattern, '') if header && header.match(pattern)
  end
end
