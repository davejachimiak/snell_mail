module SessionsHelper
  def sign_in(user)
    session[:user_token] = [user.id, user.salt]    
  end
end
