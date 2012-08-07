class NotificationMailer < ActionMailer::Base
  def mail_notification(notification)
    @notification                  = notification
    notifier                       = @notification.user
    notifier_email                 = @notification.user_email
    others_that_want_update_emails = User.others_that_want_update_emails(notifier)
    cohabitants_contact_emails     = @notification.cohabitants_contact_emails
    cohabitants_departments        = @notification.cohabitants_departments
    @departments_string = MessageSubjects.new(cohabitants_departments).construct

    notify_cohabitants(cohabitants_contact_emails, notifier_email)
    notify_admins(others_that_want_update_emails, notifier_email)
    notify_notifier(notifier_email) if notifier.wants_update?
  end

  def notify_cohabitants(cohabitants_contact_emails, notifier_email)
    subject = "You've got mail downstairs!"

    mail(to: cohabitants_contact_emails, from: notifier_email, subject: subject, template_name: 'cohabitants')
  end

  def notify_admins(others_that_want_update_emails, notifier_email)
    subject = "#{@notification.user_name} has notified cohabitants"

    mail(to: others_that_want_update_emails, from: notifier_email, subject: subject, template_name: 'admins')
  end

  def notify_notifier(notifier_email)
    subject = 'You just notified cohabitants'

    mail(to: notifier_email, from: notifier_email, subject: subject, template_name: 'notifier')
  end
end
