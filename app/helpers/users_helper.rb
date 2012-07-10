module UsersHelper
  def user_notifications
    notifications = @user.notifications
    notifications.sort_by { |n| n.created_at }.reverse
  end
end
