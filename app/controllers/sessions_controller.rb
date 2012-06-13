class SessionsController < ApplicationController

  def new
    redirect_to :controller => 'notifications', :action => 'new' if signed_in?
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user
	  redirect_to :controller => 'notifications', :action => 'new'
      session[:user_token] = user.salt
    else
      flash[:error] = 'bad email and password combintion. try again.'
      redirect_to '/'
    end
  end

  def destroy
  end
end
