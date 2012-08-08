class NotificationsController < ApplicationController
  skip_before_filter :authenticate_admin

  def index
    @notifications = Notification.order('id DESC').page(params[:page]).
      per_page(RECORDS_PER_PAGE)
  end

  def show
    @notification = Notification.find(params[:id])
  end

  def new
    @notification = Notification.new
    @cohabitants  = Cohabitant.activated
  end

  def create
    @notification = current_user.notifications.build(params[:notification])

    if @notification.save
      redirect_to notifications_path,
        flash: { "alert-success" => confirmation_message }
    else
      @cohabitants = Cohabitant.activated
      render 'new'
    end
  end

  private

    def confirmation_message
      departments = @notification.cohabitants_departments

      message_subjects = MessageSubjects.new(departments)
      beginning_of_message = message_subjects.construct

      beginning_of_message +
        'just notified that they have mail in their bins today. Thanks.'
    end
end
