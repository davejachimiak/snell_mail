class NotificationMailer < ActionMailer::Base
  def mail_notification(notification)
    notifier = notification.user_email
    cohabitants = notification.cohabitants.map { |c| c.contact_email }
    
    mail(to: cohabitants, from: notifier, subject: "You've got mail downstairs!")
  end

  def update_admins(notification)
    @notification = notification
    admins_that_want_update, notifier = set_to_and_from
    set_departments_string
    mail(from: notifier, to: admins_that_want_update, 
         subject: "#{notification.user_name} has notified cohabitants")
  end

  private

    def set_to_and_from
      [User.all.select { |u| u.email if u.wants_update? }, @notification.user_email]
    end

    def set_departments_string
      departments = @notification.cohabitants.map { |c| c.department }
      @departments_string = SnellMail::NotificationConfirmationParser.new(departments).confirmation
    end
end
