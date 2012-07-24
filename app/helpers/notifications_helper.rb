module NotificationsHelper
  def notifier(notification, admin)
    link_to notification.user_name, notification.user
  end
end