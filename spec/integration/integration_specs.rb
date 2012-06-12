require 'spec_helper'

describe "Create User integration" do
  it "redirects to user index after creation of user" do
    user = Factory(:user)
    User.create!(:name     => user.name,
                 :email    => user.email,
                 :password => user.password,
                 :admin    => user.admin)
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
    page.text.must_include "Happy Bobappy"
    page.text.must_include 'happy.bobappy@example.com'
    page.text.must_include 'delete'
    #users_page.must_include 'edit'
  end
end
