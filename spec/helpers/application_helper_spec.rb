require 'spec_helper'

describe ApplicationHelper do
  let(:admin_user)   { Factory(:user) }
  let(:non_admin_user) { Factory(:non_admin) }
  let(:cohabitant)   { Factory(:cohabitant) }
  let(:cohabitant_4) { Factory(:cohabitant_4) }
  let(:notification) { Factory(:notify_c1, user: admin_user, cohabitants: [cohabitant]) }

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
    it = notifier(notification, nil)
    it.must_equal 'Dave Jachimiak'
  end

  it '::notifier returns deleted user text if notifier was deleted' do
    Factory(:notify_c1_and_c4, user: non_admin_user, 
            cohabitants: [cohabitant, cohabitant_4])
    non_admin_user.destroy
                                  
    it = notifier(Notification.last, nil)
    it.must_equal 'deleted user'
  end

  it "::notifier returns 'A deleted user' if current url is notifications#show" do
    Factory(:notify_c1_and_c4, user: non_admin_user, 
            cohabitants: [cohabitant, cohabitant_4])
    non_admin_user.destroy
    current_url = "http::/libstaff.neu.edu/snell_mail/notifications/46"

    it = notifier(Notification.last, nil, current_url)
    it.must_equal 'A deleted user'
  end
end
