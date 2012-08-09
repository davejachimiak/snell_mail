require 'spec_helper'

describe ApplicationHelper do
  let(:admin_user)     { User.find_by_email('d.jachimiak@neu.edu') }
  let(:non_admin_user) { User.find_by_email('new.student@neu.edu') }
  let(:notification)   { Factory(:notification_with_cohabitant) }

  after do
    %w(User Cohabitant Notification).each do |model_string|
      model = Kernel.const_get(model_string)
      model.all.each { |m| m.destroy } if model.any?
    end
  end

  it '::notifier admin arg is true by default and returns link if current user is admin' do
    it = notifier(notification)
    it.must_equal self.link_to('Dave Jachimiak', admin_user)
  end

  it '::notifier returns text if current user is not admin' do
    it = notifier(notification, admin: false)
    it.must_equal 'Dave Jachimiak'
  end

  it '::notifier returns deleted user text if notifier was deleted' do
    Factory(:notification_by_non_admin_two_cohabitants)
    User.destroy(non_admin_user.id)
                                  
    it = notifier(Notification.last, admin: false)
    it.must_equal 'deleted user'
  end

  it "::notifier returns 'A deleted user' if current url is notifications#show" do
    Factory(:notification_by_non_admin_two_cohabitants)
    User.destroy(non_admin_user.id)

    it = notifier(Notification.last, admin: false, notifications_show: true)
    it.must_equal 'A deleted user'
  end
end
