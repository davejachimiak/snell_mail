require 'spec_helper'

describe "user integration" do
  FactoryGirl.create(:user)
  FactoryGirl.create(:non_admin)
  
  after do
    reset_session!
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
    click_button 'Create'
    page.text.must_include 'Happy Bobappy'
    page.text.must_include 'happy.bobappy@example.com'
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

  it "allows only admin users to resource users or cohabitants" do
    visit '/'
    fill_in 'Email', :with => 'new.student@neu.edu'
    fill_in 'Password', :with => 'password'
    click_button 'Sign in'
    page.text.wont_include 'Cohabitants'
    page.text.wont_include 'Users'
    visit '/cohabitants'
    page.current_path.must_equal '/notifications'
    page.text.must_include 'Only admin users can go to there.'
    visit '/users'
    page.current_path.must_equal '/notifications'
    page.text.must_include 'Only admin users can go to there.'
  end

  it "allows admin users to other's but doesn't not allow admin users to destroy themselves" do
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
	Capybara.use_default_driver
  end

  it "allows admin users to create other and switch users to admin users"
end
