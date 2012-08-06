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
      send_notification_and_update
    else
      render_error
    end
  end

  private

    def confirmation_message
      departments = @notification.cohabitants_departments

      message_subjects = SnellMail::MessageSubjects.new(departments)
      beginning_of_message = message_subjects.construct

      beginning_of_message +
        'just notified that they have mail in their bins today. Thanks.'
    end

    def send_notification_and_update
      NotificationMailer.mail_notification(@notification).deliver

      unless User.want_update.empty?
        if notifier_wants_update?
          NotificationMailer.update_admins(@notification, notifier_wants_update: 'notifier').deliver
        end
        NotificationMailer.update_admins(@notification).deliver
      end
    end

    def notifier_wants_update?
      email_addresses = User.want_update.map { |user| user.email }
      email_addresses.include?(@notification.user_email)
    end

    def render_error
      @cohabitants = Cohabitant.all
      @error = true
      render 'new'
    end
end
