require 'spec_helper'

describe 'all users integration' do
  let(:admin)     { User.find_by_email('d.jachimiak@neu.edu') }
  let(:non_admin) { User.find_by_email('new.student@neu.edu') }

  after do
    %w(User Cohabitant Notification).each do |model_string|
      model = Kernel.const_get(model_string)
      model.destroy_all if model.any?
    end

    ActionMailer::Base.deliveries = []
    reset_session!
  end

  describe 'with no db prep and non_admin sign in' do
    before do
      create_test_users
      Factory(:cohabitant)
      Factory(:cohabitant_4)
      test_sign_in_non_admin
    end

    it "shouldn't save notification if no cohabitants are present" do
      click_button 'Notify!'
      page.current_path.must_equal '/notifications'
      page.text.must_include "Check each cohabitant that has mail " +
                             "in their bin."
      page.text.must_include 'cohabitants must be chosen'
    end

    it "allows any user to change their password" do
      click_link 'Change password'
      fill_in 'Old password', with: 'password'
      fill_in 'New password', with: 'passwordpassword'
      fill_in 'New password again', with: 'passwordpassword'
      click_button 'Change password'
      page.current_path.must_equal '/notifications/new'
      page.text.must_include 'new password saved!'
      click_link 'Sign out'
      fill_in 'session_email', with: 'new.student@neu.edu'
      fill_in 'session_password', with: 'password'
      click_button 'Sign in'
      page.text.must_include 'bad email and password combintion. try again.'
      fill_in 'session_email', with: 'new.student@neu.edu'
      fill_in 'session_password', with: 'passwordpassword'
      click_button 'Sign in'
      page.current_path.must_equal '/notifications/new'
      click_link 'Sign out'
      fill_in 'session_email', with: 'd.jachimiak@neu.edu'
      fill_in 'session_password', with: 'password'
      click_button 'Sign in'
      click_link 'Users'
      click_button 'Edit Dave Jachimiak'
      click_link 'Change password'
      fill_in 'Old password', with: 'password'
      fill_in 'New password', with: 'passwordpassword'
      fill_in 'New password again', with: 'passwordpassword'
      click_button 'Change password'
      id = User.find_by_email('d.jachimiak@neu.edu').id
      page.current_path.must_equal "/users/#{id}/edit"
      page.text.must_include 'new password saved!'
    end

    it "shows proper messages if change password errors" do
      click_link 'Change password'
      fill_in 'Old password', with: 'passworth'
      fill_in 'New password', with: 'passwordpassword'
      fill_in 'New password again', with: 'passwordpassword'
      click_button 'Change password'
      page.text.must_include "Old password didn't match existing one"
      fill_in 'Old password', with: 'password'
      fill_in 'New password', with: 'passwordpasswork'
      fill_in 'New password again', with: 'passwordpassword'
      click_button 'Change password'
      page.text.must_include "Password confirmation doesn't match"
    end

    it "should singularize confirmation notice " +
       "for single cohabitant notifications" do
      check 'Cool Factory'
      click_button 'Notify!'
      page.text.must_include 'Cool Factory was'
    end
  end

  describe 'need cohabitant and admin' do
    before do
      Factory(:cohabitant)
      Factory(:user)
    end

    it "should talk in the second person to admin in update if they notify" do
      test_sign_in_admin
      check 'Cool Factory'
      click_button 'Notify!'
      
      update_notifier_delivery = ActionMailer::Base.deliveries.last
      update_notifier_delivery.subject.must_equal 'You just notified cohabitants'
      update_notifier_delivery.encoded.must_include 'Cool Factory was notified by you'

      update_admins_delivery = ActionMailer::Base.deliveries[-2]
      update_admins_delivery.to.wont_include 'd.jachimiak@neu.edu'
    end

    it "should notify cohabitants that they have mail " +
       "and redirect to notifications after notification" do
      Factory(:cohabitant_2)
      Factory(:cohabitant_3)
      Factory(:cohabitant_4)
      time = Time.zone.now
      test_sign_in_admin

      page.text.must_include "New notification " +
                             "for #{time.strftime("%A, %B %e, %Y")}"
      page.text.must_include "Check each cohabitant " +
                             "that has mail in their bin."
      check 'Cool Factory'
      check 'Jargon House'
      check 'Face Surgery'
      check 'Fun Section'
      click_button 'Notify!'
      page.current_path.must_equal '/notifications'
      page.text.must_include 'Cool Factory, Jargon House, Face Surgery, and Fun Section ' +
                             'were just notified ' +
                             'that they have mail ' +
                             'in their bins today. Thanks.'

      notification_email = ActionMailer::Base.deliveries[-3]
      ['d.jachimiak@neu.edu', 'waiting for you', 'cool.guy@neu.edu'].each do |text|
        notification_email.encoded.must_include text
      end
      
      update_email = ActionMailer::Base.deliveries.last
      ['Cool Factory', 'Jargon House', 'Face Surgery', 'Fun Section', 'you'].each do |text|
        update_email.encoded.must_include text
      end
    end
  end

  # needs admin user and notification by non admin two cohabitants
  it "should indicate that a deleted user made a notification" do
    Factory(:user)
    Factory(:notification_by_non_admin_two_cohabitants)
    User.destroy(non_admin.id)
    test_sign_in_admin

    click_link 'Notifications'
    page.text.must_include 'deleted user'
    click_link 'Cohabitants'
    click_link 'Cool Factory'
    page.text.must_include Time.zone.now.strftime('%A, %B %e %Y')
    page.text.must_include 'deleted user'
  end

  # needs user and all cohabitants

  describe 'admin that does not want update' do
    before do
      Factory(:cohabitant)
      Factory(:admin_no_update)
    end

    it "shouldn't notify admin if she doesn't want update" do
      create_test_users
      test_sign_in_non_admin
      
      check 'Cool Factory'
      click_button 'Notify!'
      ActionMailer::Base.deliveries.map(&:to).wont_include 'g.diaper@pamps.org'
    end

    it "shouldn't notify notifier if notifier doesn't want update" do
      visit '/'
      fill_in 'session_email', with: 'g.diaper@pamps.org'
      fill_in 'session_password', with: 'password'
      click_button 'Sign in'
      
      check 'Cool Factory'
      click_button 'Notify!'
      ActionMailer::Base.deliveries.last.subject.wont_include 'You just notified cohabitants'
      ActionMailer::Base.deliveries.last.to.wont_include 'g.diaper@pamps.org'
    end
  end

  it "should tell of all cohabitants for a given notification." do
    notification_1 = Factory(:notification_with_cohabitant)
    notification_2 = Factory(:notification_by_non_admin_two_cohabitants)
    ns_notification_link = notification_2.created_at.
                             strftime('%m.%d.%Y (%A) at %I:%M%P')

    test_sign_in_non_admin
    click_link 'Notifications'
    page.text.must_include notification_1.created_at.
      strftime('%m.%d.%Y (%A) at %I:%M%P')
    page.text.must_include ns_notification_link
    click_link ns_notification_link
    notification_2.cohabitants.each do |c| 
      page.text.must_include c.department
    end
  end
end
