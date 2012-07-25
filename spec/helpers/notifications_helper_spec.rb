require 'spec_helper'

describe NotificationsHelper do
  before do
    @admin_user = FactoryGirl.create(:user)
    @cohabitant = FactoryGirl.create(:cohabitant)
    @notification = FactoryGirl.create(:notify_c1, user: @admin_user,
                     cohabitants: [@cohabitant])
    @true_admin = true
  end

  after do
    %w(User Cohabitant Notification).each do |model_string|
      model = Kernel.const_get(model_string)
      model.all.each { |m| m.destroy } if model.any?
    end
  end

  it '#notifier returns link if current user is admin' do
    it = notifier(@notification, @true_admin)
    it.must_equal self.link_to('Dave Jachimiak', @admin_user)
  end

  it '#notifier returns text if current user is not admin' do
    it = notifier(@notification, @nil_admin)
    it.must_equal 'Dave Jachimiak'
  end

  it '#notifier returns deleted user text if notifier was deleted' do
    non_admin_user = FactoryGirl.create(:non_admin)
    cohabitant_4 = FactoryGirl.create(:cohabitant_4)
    FactoryGirl.create(:notify_c1_and_c4, user: non_admin_user, 
                       cohabitants: [@cohabitant, cohabitant_4])
    non_admin_user.destroy
    notification = Notification.last
                                  
    it = notifier(notification, @nil_admin)
    it.must_equal 'deleted user'
  end
end