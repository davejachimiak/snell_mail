require 'spec_helper'

describe "Create User integration" do
  it "redirects to user index after creation of user" do
    user = User.create!(Factory(:user))
    visit '/'
	fill_in 'Email', :with => 'd.jachimiak@neu.edu'
	fill_in 'Password', :with => 'password'
	click_button 'Sign in'
	fill_in 'User', :with => 'Happy Bobappy'
	fill_in 'Email', :with => 'happy.bobabby@example.com'
	fill_in 'Password', :with => 'password'
	click_button 'Create'
	page.text.must_include 'Happy Bobabby'
	page.text.must_include 'happy.bobabby@example.com'
	page.text.must_include 'delete'
	page.text.must_include 'edit'
  end
end