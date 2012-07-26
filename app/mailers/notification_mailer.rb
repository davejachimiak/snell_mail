class NotificationMailer < ActionMailer::Base
  def mail_notification(notification)
    from = notification.user_email
    mail(to: 'email@example.com', subject: "You've got mail downstairs!")
  end
end
