require 'spec_helper'

describe 'all users integration' do
  let(:admin) { User.find_by_email('d.jachimiak@neu.edu') }
  let(:non_admin) { User.find_by_email('new.student@neu.edu') }

  before do
    create_test_users
    cohabitant      = Factory(:cohabitant)
    cohabitant_4    = Factory(:cohabitant_4)
    @notification_1 = Factory(:notify_c1, user: admin, 
                      cohabitants: [cohabitant])
    @notification_2 = Factory(:notify_c1_and_c4,
                      user: non_admin,
                      cohabitants: [cohabitant, cohabitant_4])
  end

  after do
    %w(User Cohabitant Notification).each do |model_string|
      model = Kernel.const_get(model_string)
      model.all.each { |m| m.destroy } if model.any?
    end

    reset_session!
  end

  describe 'with no db prep' do
    before do
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

  it "should indicate that a deleted user made a notification" do
    User.destroy(non_admin.id)
    test_sign_in_admin

    click_link 'Notifications'
    page.text.must_include 'deleted user'
    click_link 'Cohabitants'
    click_link 'Cool Factory'
    page.text.must_include Time.zone.now.strftime('%A, %B %e %Y')
    page.text.must_include 'deleted user'
  end

  it "should notify cohabitants that they have mail " +
     "and redirect to notifications after notification" do
    Factory(:cohabitant_2)
    Factory(:cohabitant_3)
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
    page.text.must_include 'Cool Factory, Fun Section, Jargon House, ' +
                           'and Face Surgery were just notified ' +
                           'that they have mail ' +
                           'in their bins today. Thanks.'

    notification_email = ActionMailer::Base.deliveries[-2]
    ['d.jachimiak@neu.edu', 'waiting for you', 'cool.guy@neu.edu'].each do |text|
      notification_email.encoded.must_include text
    end
    
    update_email = ActionMailer::Base.deliveries.last
    ['Cool Factory', 'Jargon House', 'Face Surgery', 'Fun Section', 'Dave Jachimiak'].each do |text|
      update_email.encoded.must_include text
    end
  end

  it "should tell of all cohabitants for a given notification." do
    ns_notification_link = @notification_2.created_at.
                             strftime('%m.%d.%Y (%A) at %I:%M%P')

    test_sign_in_non_admin
    click_link 'Notifications'
    page.text.must_include @notification_1.created_at.
      strftime('%m.%d.%Y (%A) at %I:%M%P')
    page.text.must_include ns_notification_link
    click_link ns_notification_link
    @notification_2.cohabitants.each do |c| 
      page.text.must_include c.department
    end
  end
end
