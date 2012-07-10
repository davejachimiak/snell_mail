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
    if @notification.save
      redirect_to notifications_path, notice: notification_created_notice
    else
      @cohabitants = Cohabitant.all
      render 'new'
    end
  end

  private

  def notification_created_notice
    cohabitants = @notification.cohabitants
    if cohabitants.count > 1
      depts_arr = cohabitants.map do |c|
        c == cohabitants.last ? "and #{c.department} were " : "#{c.department}, "
      end

      depts = depts_arr.join
    else
      depts = cohabitants[0].department + ' was '
    end
    depts + 'just notified that they have mail in their bins today. Thanks.'
  end
end