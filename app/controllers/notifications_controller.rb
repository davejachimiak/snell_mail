class NotificationsController < ApplicationController
  before_filter :authenticate

  def index
    @notifications = Notification.order(:created_at).reverse
  end

  def show
    @notification = Notification.find(params[:id])
  end

  def new
    @notification = Notification.new
    @user = User.find(session[:user_token])
    @cohabitants = Cohabitant.all
  end

  def create
    @notification = Notification.new(params[:notification])
    @notification.user = current_user
    if @notification.save
      redirect_to notifications_path, :notice => notification_created_notice
    else
      @cohabitants = Cohabitant.all
      render 'new'
    end
  end

  private

    def notification_created_notice
      cohabitants = @notification.cohabitants
      Cohabitant.parse_for_notification(cohabitants) +
        'just notified that they have mail in their bins today. Thanks.'
    end
end
