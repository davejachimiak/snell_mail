require 'spec_helper'
require_relative '../../app/mailers/notification_mailer.rb'

describe 'Notification Mailer' do
  let(:notification)    { Factory(:notification_by_non_admin_two_cohabitants) }
  let(:notification_2)  { Factory(:notification_with_two_cohabitants) }

  after do
    %w(User Cohabitant Notification).each do |model_string|
      model = Kernel.const_get(model_string)
      model.destroy_all if model.any?
    end

    ActionMailer::Base.deliveries = []
  end

  describe 'notify_cohabitants' do
    subject do
      NotificationMailer.notify_cohabitants(notification).deliver
    end

    it_must { have_sent_email.with_subject(/You've got mail downstairs!/) }
    it_must { have_sent_email.from(/new.student@neu.edu/) }
    it_must { have_sent_email.to(/cool.guy@neu.edu/) }
    it_must { have_sent_email.to(/cool.lady@neu.edu/) }

    [/Hello/, /mail waiting for you in your space downstairs/, /Thank you./].each do |regex|
      it_must { have_sent_email.with_body(regex) }
    end
  end

  describe 'notify_admins' do
    subject { NotificationMailer.notify_admins(notification).deliver }

    before do
      Factory(:user)
    end

    it_must { have_sent_email.with_subject(/New Student has notified cohabitants/) }
    it_must { have_sent_email.from(/new.student@neu.edu/) }
    it_must { have_sent_email.to(/d.jachimiak@neu.edu/) }

    [/Cool Factory/, /Fun Section/].each do |regex|
      it_must { have_sent_email.with_body(regex) }
    end

    it_must { have_sent_email.with_body(/New Student/) }
  end

  describe 'notify_notifier' do
    subject { NotificationMailer.notify_notifier(notification_2).deliver }

    before do
      Factory(:user)
      Factory(:user, email: 'dave.jachimiak@gmail.com')
    end

    it_must { have_sent_email.to(/d.jachimiak@neu.edu/) }
    it_must { have_sent_email.with_subject(/You just notified cohabitants/) }
    it_must { have_sent_email.with_body(/notified by you/) }
  end
end
