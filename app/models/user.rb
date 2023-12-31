class User < ApplicationRecord
  has_many :orders

  attr_accessor :remember_token
  PASSWORD_REQUIREMENTS = /\A
    (?=.*\d)
    (?=.*[a-z])
    (?=.*[A-Z])
  /x

  validates :name, presence: true, length: { maximum: 50 }
  before_save { email.downcase! }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, format: PASSWORD_REQUIREMENTS, allow_nil: true
  
  enum role: { user: 0, admin: 1 }

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  def session_token
    remember_digest || remember
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
