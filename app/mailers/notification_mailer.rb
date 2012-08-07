class NotificationMailer < ActionMailer::Base
  def mail_notification(notification)
    @notification                  = notification
    notifier                       = @notification.user
    notifier_name                  = notifier.name
    notifier_email                 = notifier.email
    others_that_want_update_emails = notifier.others_that_want_update_emails
    cohabitants_departments        = @notification.cohabitants_departments

    notify_cohabitants(notifier)
    notify_others_that_want_update(others_that_want_update_emails)
  end

  def update_admins(notification, options={})
    @notification = notification
    want_update_addrs = set_to
    
    departments = @notification.cohabitants.map { |cohabitant| cohabitant.department }
    @departments_string = MessageSubjects.new(departments).construct

    send_update(want_update_addrs, options)
  end

  private

    def set_to
      User.want_update.select { |user| user.id != @notification.user_id }.map { |user| user.email }
    end

    def send_update(want_update_addrs, options)
      if options[:notifier_wants_update]
        send_update_to_notifier
      else
        mail(to: want_update_addrs, from: @notification.user_email,
          subject: "#{@notification.user_name} has notified cohabitants")
      end
    end
    
    def send_update_to_notifier
      @notifier = true
      mail(to: @notification.user_email, from: @notification.user_email,
        subject: "You just notified cohabitants")
    end
end
