module ApplicationHelper
  def notifier(notification, admin=true)
    unless notification.user.nil?
      admin ? link_to_user(notification) : notification.user_name
    else
     'deleted user'
    end
  end

 private

   def link_to_user(notification)
     link_to notification.user_name, notification.user
    end
end
