module ApplicationHelper
  def notifier(notification, admin=true, notifications_show=false)
    unless notification.user.nil?
      admin ? link_to_user(notification) : notification.user_name
    else
      notifications_show ? 'A deleted user' : 'deleted user'
    end
  end

 private

   def link_to_user(notification)
     link_to notification.user_name, notification.user
    end
end
