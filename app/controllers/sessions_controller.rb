class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user
	  sign_in(User.find_by_email(params[:session][:email]))
      redirect_to :controller => 'notifications', :action => 'new'
    else
      flash[:error] = 'bad email and password combintion. try again.'
      redirect_to '/'
	end
  end

  def destroy
  end
end
