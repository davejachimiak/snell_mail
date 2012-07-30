require 'spec_helper'

describe NotificationsHelper do
  let(:admin_user)   { Factory(:user) }
  let(:cohabitant)   { Factory(:cohabitant) }
  let(:cohabitant_4) { Factory(:cohabitant_4) }
  let(:notification) { Factory(:notify_c1, user: admin_user, cohabitants: [cohabitant]) }
  let(:non_admin_user) { Factory(:non_admin) }

  after do
    %w(User Cohabitant Notification).each do |model_string|
      model = Kernel.const_get(model_string)
      model.all.each { |m| m.destroy } if model.any?
    end
  end

  it '#notifier returns link if current user is admin' do
    it = notifier(notification, true)
    it.must_equal self.link_to('Dave Jachimiak', admin_user)
  end

  it '#notifier returns text if current user is not admin' do
    it = notifier(notification, nil)
    it.must_equal 'Dave Jachimiak'
  end

  it '#notifier returns deleted user text if notifier was deleted' do
    Factory(:notify_c1_and_c4, user: non_admin_user, 
            cohabitants: [cohabitant, cohabitant_4])
    non_admin_user.destroy
    last_notification = Notification.last
                                  
    it = notifier(last_notification, nil)
    it.must_equal 'deleted user'
  end
end