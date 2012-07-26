require 'spec_helper'
require_relative '../../app/mailers/notification_mailer.rb'

describe 'Notification Mailer' do
  describe 'mail_notification' do
    it "is from the student's address" do
      cohabitants = [FactoryGirl.create(:cohabitant), FactoryGirl.create(:cohabitant_4)]
      user = FactoryGirl.create(:non_admin)
      notification = FactoryGirl.create(:notify_c1_and_c4, cohabitants: cohabitants, user: user)

      email = NotificationMailer.mail_notification(notification).deliver
      email.from.must_equal ActionMailer::Base.deliveries.first.from
    end
  end
end
