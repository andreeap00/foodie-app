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
    token = bearer_token

    if token
      puts "Token found: #{token}"
      begin
        decoded_token = JWT.decode(token, ENV['JWT_SECRET_KEY'], true, algorithm: 'HS256')
        if token_not_expired(decoded_token)
          user_id = decoded_token.first['user_id']
          @current_user = User.find(user_id)
        else
          render json: { error: 'Token expired' }, status: :unauthorized
        end
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

  def token_not_expired(decoded_token)
    exp = decoded_token.first['exp']
    current_time = Time.now.to_i
    exp > current_time
  end
end
