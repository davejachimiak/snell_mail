module NotificationsHelper
  def cohabitant_of_notification(cohabitant, admin)
    admin ? link_to(cohabitant.department, cohabitant) : cohabitant.department
  end
end