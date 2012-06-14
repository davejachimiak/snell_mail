class NotificationsController < ApplicationController
  before_filter :authenticate
  
  def index
  end

  def new
    @user = User.find(session[:user_token])
  end

  def create
  end
  
end
