module SessionsHelper
  def current_user
    id = session[:user_token]
    User.find(id)
  end

  def signed_in?
    session[:user_token] ? true : false
  end

  def admin?
    User.find(session[:user_token]).admin?
  end

  def authenticate
    redirect_to '/', notice: 'please sign in to go to there.' if !signed_in?
  end

  def authenticate_admin
    redirect_to '/notifications',
      notice: 'Only admin users can go to there.' if !admin?
  end
end
