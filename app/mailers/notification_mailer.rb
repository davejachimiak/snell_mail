class NotificationMailer < ActionMailer::Base
  def mail_notification(notification)
    @notification                  = notification
    notifier                       = @notification.user
    others_that_want_update_emails = User.others_that_want_update_emails(notifier)
    cohabitants_contact_emails     = @notification.cohabitants_contact_emails
    cohabitants_departments        = @notification.cohabitants_departments
    @departments_string = MessageSubjects.new(cohabitants_departments).construct

    notify_cohabitants(cohabitants_contact_emails, notifier)
    notify_admins(others_that_want_update_emails, notifier)
    notify_notifier(notifier) if notifier.wants_update?
  end

  def notify_cohabitants(cohabitants_contact_emails, notifier)
    subject = "You've got mail downstairs!"

    mail(to: cohabitants_contact_emails, from: notifier.email, subject: subject, template_name: 'cohabitants')
  end

  def notify_admins(others_that_want_update_emails, notifier)
    subject = "#{@notification.user_name} has notified cohabitants"

    mail(to: others_that_want_update_emails, from: notifier.email, subject: subject, template_name: 'admins')
  end

  def notify_notifier(notifier)
    subject = 'You just notified cohabitants'

    mail(to: notifier.email, from: notifier.email, subject: subject, template_name: 'notifier')
  end
end
