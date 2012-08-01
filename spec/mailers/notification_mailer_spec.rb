require 'spec_helper'
require_relative '../../app/mailers/notification_mailer.rb'

describe 'Notification Mailer' do
  let(:cohabitants)     { [Factory(:cohabitant), Factory(:cohabitant_4)] }
  let(:user)            { Factory(:non_admin) }
  let(:notification)    { Factory(:notification_by_non_admin, cohabitants: cohabitants) }
  let(:notification_2)  { Factory(:notification, cohabitants: cohabitants) }

  after do
    %w(User Cohabitant Notification).each do |model_string|
      model = Kernel.const_get(model_string)
      model.all.each { |m| m.destroy } if model.any?
    end

    ActionMailer::Base.deliveries = []
  end

  describe 'mail_notification' do
    subject { NotificationMailer.mail_notification(notification).deliver }

    it_must { have_sent_email.with_subject(/You've got mail downstairs!/) }
    it_must { have_sent_email.from(/new.student@neu.edu/) }
    it_must { have_sent_email.to(/cool.guy@neu.edu/) }
    it_must { have_sent_email.to(/cool.lady@neu.edu/) }

    [/Hello/, /mail waiting for you in your space downstairs/, /Thank you./].each do |regex| 
      it_must { have_sent_email.with_body(regex) }
    end
  end

  describe 'update_admins' do
    subject { NotificationMailer.update_admins(notification).deliver }

    before do
      Factory(:user)
      Factory(:user, email: 'dave.jachimiak@gmail.com')
    end

    it_must { have_sent_email.with_subject(/New Student has notified cohabitants/) }
    it_must { have_sent_email.from(/new.student@neu.edu/) }

    User.select { |user| user.wants_update? }.map { |user| user.email }.each do |user|
      it_must { have_sent_email.to(/#{user}/) }
    end

    [/Cool Factory/, /Fun Section/].each do |regex|
      it_must { have_sent_email.with_body(regex) }
    end

    it_must { have_sent_email.with_body(/New Student/) }

    describe 'notifier wants update, mail the others' do
      subject { NotificationMailer.update_admins(notification_2).deliver }

      it_must { have_sent_email.to(/dave.jachimiak@gmail.com/) }
      it_must { have_sent_email.with_subject(/Dave Jachimiak has notified cohabitants/) }
    end

    describe 'notifier wants update, mail the notifier' do
      subject { NotificationMailer.update_admins(notification_2, notifier_wants_update: true ).deliver }

      it_must { have_sent_email.to(/d.jachimiak@neu.edu/) }
      it_must { have_sent_email.with_subject(/You just notified cohabitants/) }
      it_must { have_sent_email.with_body(/notified by you/) }
    end
  end
end
