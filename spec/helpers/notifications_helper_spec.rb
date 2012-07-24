require 'spec_helper'

admin_proc = Proc.new { |user| link_to 'Dave Jachimiak', user }

describe NotificationsHelper do
  it '#notifier returns link if current user is admin' do
    user = FactoryGirl.create(:user)
    cohabitant = FactoryGirl.create(:cohabitant)
    notification = FactoryGirl.create(:notify_c1, user: user,
                     cohabitants: [cohabitant])
    admin = true
  
    it = notifier(notification, admin)
    it.must_equal admin_proc.call(user)
  end
end