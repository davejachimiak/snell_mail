require 'spec_helper'

describe "integration" do
  FactoryGirl.create(:user)
  FactoryGirl.create(:non_admin)
  
  describe "user integration" do
    after do
      reset_session!
    end
 
    it "redirects to sign in page if bad email and password combo" do
      visit '/'
      fill_in 'session_email', :with => 'd.jachimik@neu.edu'
      fill_in 'session_password', :with => 'passord'
      click_button 'Sign in'
      page.current_path.must_equal '/'
      page.text.must_include 'bad email and password combintion. try again.'
    end
  
    it "doesn't show header if you aren't signed in" do
      visit '/'
      page.text.wont_include 'Users'
    end
  
    it "doesn't allow non-signed in users to visit sensitive paths" do
      visit '/users'
      page.current_path.must_equal '/'
      page.text.must_include 'please sign in to go to there.'
      visit '/notifications'
      page.current_path.must_equal '/'
      page.text.must_include 'please sign in to go to there.'
      visit '/cohabitants'
      page.current_path.must_equal '/'
      page.text.must_include 'please sign in to go to there.'
    end
  end

  describe "non-admin sign-in integration" do
    before do
      visit '/'
      fill_in 'session_email', :with => 'new.student@neu.edu'
      fill_in 'session_password', :with => 'password'
      click_button 'Sign in'
    end

    after do
      reset_session!
    end
    
    it "does not allow a user to change another's password" do
      another_users_id = User.find_by_email('d.jachimiak@neu.edu').id
      visit "/users/#{another_users_id}/password"
      page.current_path.must_equal '/notifications/new'
      page.text.must_include 'idiot'
    end

    it "allows only admin users to resource users or cohabitants" do
      page.text.wont_include 'Cohabitants'
      page.text.wont_include 'Users'
      visit '/cohabitants'
      page.current_path.must_equal '/notifications'
      page.text.must_include 'Only admin users can go to there.'
      visit '/users'
      page.current_path.must_equal '/notifications'
      page.text.must_include 'Only admin users can go to there.'
    end
    
    it "allows any user to change their password" do
      click_link 'Change password'
      fill_in 'Old password', :with => 'password'
      fill_in 'New password', :with => 'passwordpassword'
      fill_in 'New password again', :with => 'passwordpassword'
      click_button 'Change password'
      page.current_path.must_equal '/notifications/new'
      page.text.must_include 'new password saved!'
      click_link 'Sign out'
      fill_in 'session_email', :with => 'new.student@neu.edu'
      fill_in 'session_password', :with => 'password'
      click_button 'Sign in'
      page.text.must_include 'bad email and password combintion. try again.'
      fill_in 'session_email', :with => 'new.student@neu.edu'
      fill_in 'session_password', :with => 'passwordpassword'
      click_button 'Sign in'
      page.current_path.must_equal '/notifications/new'
      click_link 'Sign out'
      fill_in 'session_email', :with => 'd.jachimiak@neu.edu'
      fill_in 'session_password', :with => 'password'
      click_button 'Sign in'
      click_link 'Users'
      click_button 'Edit Dave Jachimiak'
      click_link 'Change password'
      fill_in 'Old password', :with => 'password'
      fill_in 'New password', :with => 'passwordpassword'
      fill_in 'New password again', :with => 'passwordpassword'
      click_button 'Change password'
      id = User.find_by_email('d.jachimiak@neu.edu').id
      page.current_path.must_equal "/users/#{id}/edit"
      page.text.must_include 'new password saved!'
      User.find_by_email('new.student@neu.edu').update_attributes(:password => 'password',
                                                                  :password_confirmation => 'password')
      User.find_by_email('d.jachimiak@neu.edu').update_attributes(:password => 'password',
                                                                  :password_confirmation => 'password')
    end
  end

  describe "admin sign-in integration" do
    after do
      reset_session!
    end

    it "allows admin users to destroy other's but doesn't not allow admin users to destroy themselves" do
      Capybara.current_driver = :selenium
      visit '/'
      fill_in 'session_email', :with => 'd.jachimiak@neu.edu'
      fill_in 'session_password', :with => 'password'
      click_button 'Sign in'
      click_link 'Users'
      click_button 'Delete New Student'
      page.driver.browser.switch_to.alert.accept
      page.current_path.must_equal '/users'
      page.text.wont_include 'New Student'
      page.body.wont_include 'Delete Dave Jachimiak'
      click_link 'Users'
      click_link 'New user'
      fill_in 'user_name', :with => 'New Student'
      fill_in 'user_email', :with => 'new.student@neu.edu'
      fill_in 'user_password', :with => 'password'
      fill_in 'user_password_confirmation', :with => 'password'
      click_button 'Create'
      click_link 'Sign out'
      Capybara.current_driver = :rack_test
    end
  
    it "allows admin users to create other and switch users to admin users" do
      visit '/'
      fill_in 'session_email', :with => 'd.jachimiak@neu.edu'
      fill_in 'session_password', :with => 'password'
      click_button 'Sign in'
      click_link 'Users'
      click_button 'Edit New Student'
      fill_in 'user_email', :with => 'old.student@neu.edu'
      check 'Admin'
      click_button 'Save'
      page.current_path.must_equal '/users'
      page.text.must_include 'old.student@neu.edu'
      User.find_by_email('old.student@neu.edu').
        update_attributes(:email => 'new.student@neu.edu',
                          :admin => false)
    end
  
    it "allows user to sign out" do
      visit '/'
      fill_in 'session_email', :with => 'd.jachimiak@neu.edu'
      fill_in 'session_password', :with => 'password'
      click_button 'Sign in'
      click_link 'Sign out'
      page.current_path.must_equal '/'
      visit '/notifications'
      page.current_path.must_equal '/'
      page.text.must_include 'please sign in to go to there.'
    end
  
    it "redirects to user index after admin creates user" do
      visit '/'
      fill_in 'session_email', :with => 'd.jachimiak@neu.edu'
      fill_in 'session_password', :with => 'password'
      click_button 'Sign in'
      click_link 'Users'
      click_link 'New user'
      fill_in 'user_name', :with => 'Happy Bobappy'
      fill_in 'user_email', :with => 'happy.bobappy@example.com'
      fill_in 'user_password', :with => 'password'
      fill_in 'user_password_confirmation', :with => 'password'
      click_button 'Create'
      page.text.must_include 'Happy Bobappy'
      page.text.must_include 'happy.bobappy@example.com'
    end

    it "show all notifications for a given user" do
      cohabitant = FactoryGirl.create(:cohabitant)
      
      notification_1 = FactoryGirl.create(:notify_c1, 
        :user => User.find_by_email('new.student@neu.edu'),
        :cohabitants => [cohabitant])
      notification_2 = FactoryGirl.create(:notify_c1_and_c4,
        :user => User.find_by_email('new.student@neu.edu'),
        :cohabitants => [cohabitant, FactoryGirl.create(:cohabitant_4)])

      visit '/'
      fill_in 'session_email', :with => 'd.jachimiak@neu.edu'
      fill_in 'session_password', :with => 'password'
      click_button 'Sign in'
      click_link 'Users'
      click_link 'New Student'
      page.text.must_include notification_1.created_at.strftime('%m.%d.%Y (%A) at %I:%M%P')
      page.text.must_include notification_2.created_at.strftime('%m.%d.%Y (%A) at %I:%M%P')
      Notification.all.each { |n| n.destroy }
      Cohabitant.all.each { |c| c.destroy }
    end
  end

  describe "valid cohabitants integration" do
    after do
      reset_session!
    end

    it "should allow admin users to create and edit cohabitants" do
      visit '/'
      fill_in 'session_email', :with => 'd.jachimiak@neu.edu'
      fill_in 'session_password', :with => 'password'
      click_button 'Sign in'
      click_link 'Cohabitants'
      click_link 'New cohabitant'
      fill_in 'cohabitant_department', :with => 'EdTech'
      fill_in 'cohabitant_location', :with => '242SL'
      fill_in 'cohabitant_contact_name', :with => 'Cool Lady'
      fill_in 'cohabitant_contact_email', :with => 'cool.lady@neu.edu'
      click_button 'Create'
      page.current_path.must_equal '/cohabitants'
      page.text.must_include 'EdTech'
      page.text.must_include '242SL'
      page.text.must_include 'Cool Lady'
      page.text.must_include 'cool.lady@neu.edu'
      click_button 'Edit EdTech'
      fill_in 'cohabitant_location', :with => '259SL'
      fill_in 'cohabitant_contact_name', :with => 'Cool Dude'
      fill_in 'cohabitant_contact_email', :with => 'cool.dude@neu.edu'
      click_button 'Edit'
      page.current_path.must_equal '/cohabitants'
      page.text.wont_include 'cool.lady@neu.edu'
      page.text.must_include 'cool.dude@neu.edu'
      Cohabitant.find_by_contact_email('cool.dude@neu.edu').destroy
    end

    it "allows admin users to destroy cohabitants" do
      Capybara.current_driver = :selenium
      visit '/'
      fill_in 'session_email', :with => 'd.jachimiak@neu.edu'
      fill_in 'session_password', :with => 'password'
      click_button 'Sign in'
      click_link 'Cohabitants'
      click_link 'New cohabitant'
      fill_in 'cohabitant_department', :with => 'EdTech'
      fill_in 'cohabitant_location', :with => '242SL'
      fill_in 'cohabitant_contact_name', :with => 'Cool Lady'
      fill_in 'cohabitant_contact_email', :with => 'cool.lady@neu.edu'
      click_button 'Create'
      click_button 'Delete EdTech'
      page.driver.browser.switch_to.alert.accept
      page.current_path.must_equal '/cohabitants'
      page.text.wont_include 'Cool Lady'
      Capybara.current_driver = :rack_test
    end

    it "allows admin users to deactivate cohabitants" do
      
    end
    
    it "shows all notifications for a given cohabitant" do
      cohabitant = FactoryGirl.create(:cohabitant)
      cohabitant_4 = FactoryGirl.create(:cohabitant_4)
      FactoryGirl.create(:notify_c1, 
        :user => User.find_by_email('d.jachimiak@neu.edu'),
        :cohabitants => [cohabitant] )
      FactoryGirl.create(:notify_c1_and_c4,
        :user => User.find_by_email('new.student@neu.edu'),
        :cohabitants => [cohabitant, cohabitant_4] )
      visit '/'
      fill_in 'session_email', :with => 'd.jachimiak@neu.edu'
      fill_in 'session_password', :with => 'password'
      click_button 'Sign in'
      click_link 'Cohabitants'
      click_link 'Cool Factory'
      page.text.must_include Time.zone.now.strftime('%A, %B %e %Y')
      page.text.must_include "Dave Jachimiak"
      page.text.must_include "New Student"
      Cohabitant.all.each { |c| c.destroy }
      Notification.all.each { |n| n.destroy }
    end

    it "gives a friendly message if a cohabitant has no notifications" do
      cohabitant = FactoryGirl.create(:cohabitant)
      visit '/'
      fill_in 'session_email', :with => 'd.jachimiak@neu.edu'
      fill_in 'session_password', :with => 'password'
      click_button 'Sign in'
      click_link 'Cohabitants'
      click_link 'Cool Factory'
      page.text.must_include 'Cool Factory has never been notified.'
      Cohabitant.all.each { |c| c.destroy }
    end
  end

  describe "invalid cohabitant attributes integration" do
    after do
      reset_session!
    end

    it "won't save new cohabitant" do
      check_inclusion = Proc.new { |string| page.text.must_include string }
      inclusion_strings = ["department can't be blank", "location can't be blank",
        "contact name can't be blank", "contact email can't be blank"]
	  
      visit '/'
      fill_in 'session_email', :with => 'd.jachimiak@neu.edu'
      fill_in 'session_password', :with => 'password'
      click_button 'Sign in'
      click_link 'Cohabitants'
      click_link 'New cohabitant'
      click_button 'Create'
      page.current_path.must_equal '/cohabitants'
      inclusion_strings.each { |string| check_inclusion.call(string) }
      fill_in 'cohabitant_department', :with => 'Cool Factory'
      fill_in 'cohabitant_location', :with => '242SL'
      fill_in 'cohabitant_contact_name', :with => 'Cool Lady'
      fill_in 'cohabitant_contact_email', :with => 'cool.ladyneu.edu'
      click_button 'Create'
      page.text.must_include 'contact email is invalid'
    end  
  end

  describe "notification integration" do
    before do
      @cohabitant   = FactoryGirl.create(:cohabitant)
      @cohabitant_2 = FactoryGirl.create(:cohabitant_2)
      @cohabitant_3 = FactoryGirl.create(:cohabitant_3)
      @cohabitant_4 = FactoryGirl.create(:cohabitant_4)
      @time = Time.now
      visit '/'
      fill_in 'session_email', :with => 'd.jachimiak@neu.edu'
      fill_in 'session_password', :with => 'password'
      click_button 'Sign in'
    end
    
    after do 
      Cohabitant.all.each { |c| c.destroy }
      reset_session!
    end

    it "should notify cohabitants that they have mail and redirect to notifications after notification" do
      page.text.must_include "New notification for #{@time.strftime("%A, %B %e, %Y")}"
      page.text.must_include "Check each cohabitant that has mail in their bin."
      check 'Cool Factory'
      check 'Jargon House'
      check 'Face Surgery'
      check 'Fun Section'
      click_button 'Notify!'
      page.current_path.must_equal '/notifications'
      page.text.must_include 'Cool Factory, Jargon House, Face Surgery, and Fun Section were just notified ' +
                             'that they have mail in their bins today. Thanks.'
      Notification.all.each { |n| n.destroy }
    end
	
    it "should singularize confirmation notice for single cohabitant notifications" do
      check 'Fun Section'
      click_button 'Notify!'
      page.text.must_include 'Fun Section was'
      Notification.all.each { |n| n.destroy }
    end
	
    it "shouldn't save notification if no cohabitants are present" do
      click_button 'Notify!'
      page.current_path.must_equal '/notifications'
      page.text.must_include "Check each cohabitant that has mail in their bin."
      page.text.must_include 'cohabitants must be chosen'
    end

    it "should tell of all cohabitants for a given notification." do
      notification_1 = FactoryGirl.create(:notify_c1, 
        :user => User.find_by_email('d.jachimiak@neu.edu'),
        :cohabitants => [@cohabitant])
      notification_2 = FactoryGirl.create(:notify_c1_and_c4,
        :user => User.find_by_email('new.student@neu.edu'),
        :cohabitants => [@cohabitant, @cohabitant_4])
      
      ns_notification_link = notification_2.created_at.strftime('%m.%d.%Y (%A) at %I:%M%P')

      click_link 'Notifications'
      page.text.must_include notification_1.created_at.strftime('%m.%d.%Y (%A) at %I:%M%P')
      page.text.must_include ns_notification_link
      click_link ns_notification_link
      notification_2.cohabitants.each { |c| page.text.must_include c.department }
      Notification.all.each { |n| n.destroy }
    end

    it "should indicate that a deleted user made a notification" do
      user = User.find_by_email('new.student@neu.edu')
      FactoryGirl.create(:notify_c1_and_c4,
        :user => user,
        :cohabitants => [@cohabitant, @cohabitant_4] )
      User.destroy(user.id)
      
      click_link 'Notifications'
      page.text.must_include 'deleted user'
      click_link 'Cohabitants'
      click_link 'Cool Factory'
      page.text.must_include Time.zone.now.strftime('%A, %B %e %Y')
      page.text.must_include 'deleted user'
      FactoryGirl.create(:non_admin)
    end
  end
end
