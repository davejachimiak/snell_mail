class SessionsController < ApplicationController
  skip_before_filter :authenticate, :authenticate_admin

  def new
    redirect_to controller: 'notifications', action: 'new' if signed_in?
  end

  def create
    user = User.find_by_email(params[:session][:email])

    if user && user_authenticates?(user)
      redirect_to controller: 'notifications', action: 'new'
      session[:user_token] = user.id
    else
      flash[:error] = 'bad email and password combintion. try again.'
      redirect_to :root
    end
  end

  def destroy
    reset_session
    redirect_to :root
  end

  private

    def user_authenticates?(user)
      user.authenticate(params[:session][:password])
    end
end
