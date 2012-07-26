class NotificationMailer < ActionMailer::Base
  def mail_notification(notification)
    notifier = notification.user_email
    cohabitants = notification.cohabitants.map { |c| c.contact_email }
    mail(to: cohabitants, from: notifier, subject: "You've got mail downstairs!")
  end

  def update_admins(notification)
    notifier = notification.user_email
    admins_that_want_update = User.all.select { |u| u.wants_update? }.map { |u| u.email }

    @notification = notification

    departments = notification.cohabitants.map { |c| c.department }
    @departments_string = SnellMail::NotificationConfirmationParser.new(departments).confirmation

    mail(from: notifier, to: admins_that_want_update, subject: "#{notification.user_name} has notified cohabitants")
  end
end
