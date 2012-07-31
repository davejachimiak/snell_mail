class NotificationMailer < ActionMailer::Base
  def mail_notification(notification)
    notifier = notification.user_email
    cohabitants = notification.cohabitants.map { |cohabitant| cohabitant.contact_email }

    mail(to: cohabitants, from: notifier, subject: "You've got mail downstairs!")
  end

  def update_admins(notification)
    @notification = notification
    admins_that_want_update, notifier = set_to_and_from
    departments = @notification.cohabitants.map { |cohabitant| cohabitant.department }
    @departments_string = SnellMail::NotificationConfirmationParser.new(departments).confirmation
    
    mail(to: admins_that_want_update, from: notifier,
      subject: "#{@notification.user_name} has notified cohabitants")
  end

  private

    def set_to_and_from
      [User.all.select { |user| user.wants_update? }.map { |user| user.email }, @notification.user_email]
    end
end
