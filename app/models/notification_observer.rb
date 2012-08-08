class NotificationObserver < ActiveRecord::Observer
  def after_create(notification)
    NotificationMailer.notify_cohabitants(notification).deliver
    NotificationMailer.notify_admins(notification).deliver
    NotificationMailer.notify_notifier(notification).deliver if notification.user.wants_update?
  end
end
