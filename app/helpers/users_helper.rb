module UsersHelper
  def user_email(user, current_user_id)
    unless current_user_id == user.id
      mail_to_user_email(user)
    else
      user.email
    end
  end
  
  private
  
    def mail_to_user_email(user)
      mail_to user.email
    end
end