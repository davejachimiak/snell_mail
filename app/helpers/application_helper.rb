module ApplicationHelper
  def notifier(notification, options={})
    options.reverse_merge!({admin: true})

    unless notification.user.nil?
      options[:admin] ? link_to_user(notification) : notification.user_name
    else
      options[:notifications_show] ? 'A deleted user' : 'deleted user'
    end
  end

 private

   def link_to_user(notification)
     link_to notification.user_name, notification.user
    end
end
