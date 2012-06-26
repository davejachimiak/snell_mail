class NotificationsController < ApplicationController
  before_filter :authenticate
  
  def index
  end

  def new
    @notification = Notification.new
    @user = User.find(session[:user_token])
    @cohabitants = Cohabitants.all
  end

  def create
  end
end
