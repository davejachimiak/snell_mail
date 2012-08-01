class NotificationMailer < ActionMailer::Base
  def mail_notification(notification)
    notifier = notification.user_email
    cohabitants = notification.cohabitants.map { |cohabitant| cohabitant.contact_email }

    mail(to: cohabitants, from: notifier, subject: "You've got mail downstairs!")
  end

  def update_admins(notification, options={})
    @notification = notification
    admins_that_want_update, notifier = set_to_and_from
    departments = @notification.cohabitants.map { |cohabitant| cohabitant.department }
    @departments_string = SnellMail::NotificationConfirmer.new(departments).departments_string
    notifier_options = options[:notifier_wants_update]

    if notifier_options
      if notifier_options == 'others'
        admins_that_want_update.delete(notifier)
        mail(to: admins_that_want_update, from: notifier,
          subject: "#{@notification.user_name} has notified cohabitants")
      else
        @notifier = true
        mail(to: notifier, from: notifier,
          subject: "You just notified cohabitants")
      end
    else
      mail(to: admins_that_want_update, from: notifier,
        subject: "#{@notification.user_name} has notified cohabitants")
    end
  end

  private

    def set_to_and_from
      [User.want_update.map { |user| user.email }, @notification.user_email]
    end
end
