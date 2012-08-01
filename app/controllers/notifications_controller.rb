class NotificationsController < ApplicationController
  before_filter :authenticate

  def index
    @notifications = Notification.order('id DESC').page(params[:page]).
      per_page(15)
  end

  def show
    @notification = Notification.find(params[:id])
  end

  def new
    @notification = Notification.new
    @user         = current_user
    @cohabitants  = Cohabitant.all.select do |cohabitant|
                      cohabitant if cohabitant.activated?
                    end
  end

  def create
    @notification      = Notification.new(params[:notification])
    @notification.user = current_user
    if @notification.save
      redirect_to notifications_path,
        flash: { "alert-success" => notification_confirmation }
      send_notification_and_update
    else
      render_errors
    end
  end

  private

    def notification_confirmation
      cohabitants = @notification.cohabitants
      departments = cohabitants.map { |cohabitant| cohabitant.department }
      confirmer = SnellMail::NotificationConfirmer.new(departments)
      confirmer.departments_string +
        'just notified that they have mail in their bins today. Thanks.'
    end

    def send_notification_and_update
      NotificationMailer.mail_notification(@notification).deliver
      
      unless User.want_update.empty?
        if notifier_wants_update?
          NotificationMailer.update_admins(@notification, notifier_wants_update: 'others').deliver
          NotificationMailer.update_admins(@notification, notifier_wants_update: 'notifier').deliver
        else
          NotificationMailer.update_admins(@notification).deliver
        end
      end
    end
    
    def notifier_wants_update?
      email_addresses = User.want_update.map { |user| user.email }
      email_addresses.include?(@notification.user_email)
    end

    def render_errors
      @cohabitants = Cohabitant.all
      @error = true
      render 'new'
    end
end
