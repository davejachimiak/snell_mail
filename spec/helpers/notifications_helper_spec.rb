require 'spec_helper'

describe NotificationsHelper do
  let(:cohabitant) { Factory(:cohabitant) }

  it '::cohabitant_of_notification is responsive on module' do
    self.must_respond_to :cohabitant_of_notification
  end
  
  it '::cohabitant_of_notification links to cohabitant if user is admin' do
    it = cohabitant_of_notification(cohabitant, true)
    it.must_equal(link_to cohabitant.department, cohabitant)
  end
  
  it '::cohabitant_of_notification just shows text of department if user is not admin' do
    it = cohabitant_of_notification(cohabitant, false)
    it.must_equal cohabitant.department
  end
end