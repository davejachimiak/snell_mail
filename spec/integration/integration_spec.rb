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
      fill_in 'Email', :with => 'd.jachimik@neu.edu'
      fill_in 'Password', :with => 'passord'
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
      fill_in 'Email', :with => 'new.student@neu.edu'
      fill_in 'Password', :with => 'password'
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
      fill_in 'Email', :with => 'new.student@neu.edu'
      fill_in 'Password', :with => 'password'
      click_button 'Sign in'
      page.text.must_include 'bad email and password combintion. try again.'
      fill_in 'Email', :with => 'new.student@neu.edu'
      fill_in 'Password', :with => 'passwordpassword'
      click_button 'Sign in'
      page.current_path.must_equal '/notifications/new'
      click_link 'Sign out'
      fill_in 'Email', :with => 'd.jachimiak@neu.edu'
      fill_in 'Password', :with => 'password'
      click_button 'Sign in'
      click_link 'Users'
      click_link 'Edit Dave Jachimiak'
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
      fill_in 'Email', :with => 'd.jachimiak@neu.edu'
      fill_in 'Password', :with => 'password'
      click_button 'Sign in'
      click_link 'Users'
      click_link 'Delete New Student'
      page.driver.browser.switch_to.alert.accept
      page.current_path.must_equal '/users'
      page.text.wont_include 'New Student'
      page.body.wont_include 'Delete Dave Jachimiak'
      click_link 'Users'
      click_link 'New user'
      fill_in 'Name', :with => 'New Student'
      fill_in 'Email', :with => 'new.student@neu.edu'
      fill_in 'Password', :with => 'password'
      fill_in 'Password confirmation', :with => 'password'
      click_button 'Create'
      click_link 'Sign out'
      Capybara.current_driver = :rack_test
    end
  
    it "allows admin users to create other and switch users to admin users" do
      visit '/'
      fill_in 'Email', :with => 'd.jachimiak@neu.edu'
      fill_in 'Password', :with => 'password'
      click_button 'Sign in'
      click_link 'Users'
      click_link 'Edit New Student'
      fill_in 'Email', :with => 'old.student@neu.edu'
      fill_in 'Name', :with => 'Old Student'
      check 'Admin'
      click_button 'Save'
      page.current_path.must_equal '/users'
      page.text.must_include 'old.student@neu.edu'
      page.text.must_include 'Old Student'
      FactoryGirl.create(:non_admin)
    end
  
    it "allows user to sign out" do
      visit '/'
      fill_in 'Email', :with => 'd.jachimiak@neu.edu'
      fill_in 'Password', :with => 'password'
      click_button 'Sign in'
      click_link 'Sign out'
      page.current_path.must_equal '/'
      visit '/notifications'
      page.current_path.must_equal '/'
      page.text.must_include 'please sign in to go to there.'
    end
  
    it "redirects to user index after admin creates user" do
      visit '/'
      fill_in 'Email', :with => 'd.jachimiak@neu.edu'
      fill_in 'Password', :with => 'password'
      click_button 'Sign in'
      click_link 'Users'
      click_link 'New user'
      fill_in 'Name', :with => 'Happy Bobappy'
      fill_in 'Email', :with => 'happy.bobappy@example.com'
      fill_in 'Password', :with => 'password'
      fill_in 'Password confirmation', :with => 'password'
      click_button 'Create'
      page.text.must_include 'Happy Bobappy'
      page.text.must_include 'happy.bobappy@example.com'
    end
  end

  describe "valid cohabitants integration" do
    after do
      reset_session!
    end

    it "should allow admin users to create and edit cohabitants" do
      visit '/'
      fill_in 'Email', :with => 'd.jachimiak@neu.edu'
      fill_in 'Password', :with => 'password'
      click_button 'Sign in'
      click_link 'Cohabitants'
      click_link 'New cohabitant'
      fill_in 'Department', :with => 'EdTech'
      fill_in 'Location', :with => '242SL'
      fill_in 'Contact name', :with => 'Cool Lady'
      fill_in 'Contact email', :with => 'cool.lady@neu.edu'
      click_button 'Create'
      page.current_path.must_equal '/cohabitants'
      page.text.must_include 'EdTech'
      page.text.must_include '242SL'
      page.text.must_include 'Cool Lady'
      page.text.must_include 'cool.lady@neu.edu'
      click_link 'Edit EdTech'
      fill_in 'Location', :with => '259SL'
      fill_in 'Contact name', :with => 'Cool Dude'
      fill_in 'Contact email', :with => 'cool.dude@neu.edu'
      click_button 'Edit'
      page.current_path.must_equal '/cohabitants'
      page.text.wont_include 'cool.lady@neu.edu'
      page.text.must_include 'cool.dude@neu.edu'
      Cohabitant.find_by_contact_email('cool.dude@neu.edu').destroy
    end

    it "allows admin users to destroy cohabitants" do
      Capybara.current_driver = :selenium
      visit '/'
      fill_in 'Email', :with => 'd.jachimiak@neu.edu'
      fill_in 'Password', :with => 'password'
      click_button 'Sign in'
      click_link 'Cohabitants'
      click_link 'New cohabitant'
      fill_in 'Department', :with => 'EdTech'
      fill_in 'Location', :with => '242SL'
      fill_in 'Contact name', :with => 'Cool Lady'
      fill_in 'Contact email', :with => 'cool.lady@neu.edu'
      click_button 'Create'
      click_link 'Delete EdTech'
      page.driver.browser.switch_to.alert.accept
      page.current_path.must_equal '/cohabitants'
      page.text.wont_include 'Cool Lady'
      Capybara.current_driver = :rack_test
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
      fill_in 'Email', :with => 'd.jachimiak@neu.edu'
      fill_in 'Password', :with => 'password'
      click_button 'Sign in'
      click_link 'Cohabitants'
      click_link 'New cohabitant'
      click_button 'Create'
      page.current_path.must_equal '/cohabitants'
      inclusion_strings.each { |string| check_inclusion.call(string) }
      fill_in 'Department', :with => 'Cool Factory'
      fill_in 'Location', :with => '242SL'
      fill_in 'Contact name', :with => 'Cool Lady'
      fill_in 'Contact email', :with => 'cool.ladyneu.edu'
      click_button 'Create'
      page.text.must_include 'contact email is invalid'
    end  
  end

  describe "valid notification integrations" do
    before do
      FactoryGirl.create(:cohabitant)
      FactoryGirl.create(:cohabitant_2)
      FactoryGirl.create(:cohabitant_3)
      FactoryGirl.create(:cohabitant_4)
    end
    
    after do 
      reset_session!
    end

    it "should notify cohabitants that they have mail and redirect to notifications after notification" do
      time = Time.now
      visit '/'
      fill_in 'Email', :with => 'new.student@neu.edu'
      fill_in 'Password', :with => 'password'
      click_button 'Sign in'
      page.text.must_include "New notification for #{time.strftime("%A, %B %e, %Y")}"
      page.text.must_include "Check each cohabitant that has mail in their bin."
      check 'Cool Factory'
      check 'Jargon House'
      check 'Drugs'
      check 'Fun Section'
      click_button 'Notify!'
      page.current_path.must_equal '/notifications'
      page.text.must_include 'Cool Factory, Jargon House, Drugs, and Fun Section were just notified ' +
                             'that they have mail in their bins today. Thanks'
    end
  end
end
