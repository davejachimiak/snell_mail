require 'spec_helper'
require_relative '../../app/mailers/notification_mailer.rb'

describe 'Notification Mailer' do
  let(:cohabitants)     { [Factory(:cohabitant), Factory(:cohabitant_4)] }
  let(:user)            { Factory(:non_admin) }
  let(:notification)    { Factory(:notify_c1_and_c4, cohabitants: cohabitants, user: user) }
  let(:delivered_email) { ActionMailer::Base.deliveries.last }
  
  after do
    %w(User Cohabitant Notification).each do |model_string|
      model = Kernel.const_get(model_string)
      model.all.each { |m| m.destroy } if model.any?
    end
    
    ActionMailer::Base.deliveries = []
  end

  describe 'mail_notification' do
    before do
      NotificationMailer.mail_notification(notification).deliver
    end

    it "is from the student's address" do
      delivered_email.from.first.must_equal notification.user_email
    end

    it "is to all of the cohabitants selected for notification" do
      delivered_email.to.must_equal notification.cohabitants.map { |c| c.contact_email }
    end

    it "subject is friendly" do
      delivered_email.subject.must_equal "You've got mail downstairs!"
    end

    it "body contains friendly message" do
      delivered_email.encoded.must_match /Hello/
      delivered_email.encoded.must_match /mail waiting for you in your space downstairs/
      delivered_email.encoded.must_match /Thank you./
    end
  end

  describe 'update_admins' do
    before do
      Factory(:user, wants_update: true)
      NotificationMailer.update_admins(notification).deliver
    end

    it "is from the student's address" do
      delivered_email.from.first.must_equal notification.user_email
    end

    it "is to all of the admins selected for notification of notification" do
      delivered_email.to.must_equal User.select { |u| u.wants_update? }.map { |u| u.email }
    end

    it "subject is telling of action and person who did it" do
      delivered_email.subject.must_equal "#{notification.user_name} has notified cohabitants"
    end

    it "body contains informative message" do
      department_names = notification.cohabitants.map { |c| c.department }
      department_names.each { |d| delivered_email.encoded.must_include d }
      delivered_email.encoded.must_include notification.user_name
    end
  end
end
