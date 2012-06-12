class SessionsController < ApplicationController
  def new
    @title = 'Sign in'
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])    
    redirect_to :controller => 'notifications', :action => 'index'
  end

  def destroy
  end
end
