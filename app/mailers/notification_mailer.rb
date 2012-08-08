class NotificationMailer < ActionMailer::Base
  def notify_cohabitants(notification)
    cohabitants_contact_emails = notification.cohabitants_contact_emails
    notifier_email = notification.user_email
    subject = "You've got mail downstairs!"

    mail(to: cohabitants_contact_emails, from: notifier_email, subject: subject, template_name: 'cohabitants')
  end

  def notify_admins(notification)
    @notification = notification
    other_admins = User.others_that_want_update_emails(@notification.user)
    set_departments_string
    subject = "#{notification.user_name} has notified cohabitants"

    mail(to: other_admins, from: notification.user_email, subject: subject, template_name: 'admins')
  end

  def notify_notifier(notification)
    @notification = notification
    notifier_email = @notification.user_email
    set_departments_string
    subject = 'You just notified cohabitants'

    mail(to: notifier_email, from: notifier_email, subject: subject, template_name: 'notifier')
  end

  private
    def set_departments_string
      cohabitants_departments = @notification.cohabitants_departments
      @departments_string = MessageSubjects.new(cohabitants_departments).construct
    end
end
