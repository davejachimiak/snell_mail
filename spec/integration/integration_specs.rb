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
    fill_in 'Email', :with => 'happy.bobabby@example.com'
    fill_in 'Password', :with => 'password'
    click_button 'Create'
    users_page = page.text.split("\n  ")
    users_page.must_include "Happy Bobabby"
    users_page.must_include 'happy.bobabby@example.com'
    users_page.must_include 'delete'
    users_page.must_include 'edit'
  end
end
