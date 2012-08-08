class NotificationsController < ApplicationController
  before_filter :authenticate

  def index
    @notifications = Notification.order('id DESC').page(params[:page]).
      per_page(RECORDS_PER_PAGE)
  end

  def show
    @notification = Notification.find(params[:id])
  end

  def new
    @notification = Notification.new
    @user         = current_user
    @cohabitants  = Cohabitant.activated
  end

  def create
    @notification = current_user.notifications.build(params[:notification])

    if @notification.save
      redirect_to notifications_path,
        flash: { "alert-success" => confirmation_message }
    else
      render_error
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

    def render_error
      @cohabitants = Cohabitant.all
      @error = true
      render 'new'
    end
end
