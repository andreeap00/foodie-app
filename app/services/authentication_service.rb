module AuthenticationService
  def self.authenticate_user(request)
    user_id = JwtService.decode(auth_token(request))['user_id'] if auth_token(request)
    User.find_by(id: user_id) if user_id
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    nil
  end

  private

  def self.auth_token(request)
    request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?
  end

  # ex-sessions_helper content
  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find(user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find(user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    current_user.present?
  end

  def authenticate
    redirect_to login_path if current_user.nil? && !logged_in?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end
end
