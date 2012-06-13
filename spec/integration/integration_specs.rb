require 'spec_helper'

describe "user integration" do
  it "redirects to user index after creation of user" do
    Factory(:user)
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
    Factory(:user)
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
end
