class JwtService
  SECRET_KEY = ENV['SECRET_KEY_BASE']

  def self.encode(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded_token = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded_token)
  rescue JWT::DecodeError
    nil
  end
end
