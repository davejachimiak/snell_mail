require 'spec_helper'

describe 'sign in and out integration' do
  before do
    create_test_users
  end

  after do
    User.all.each { |user| user.destroy } if User.any?

    reset_session!
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

  it "redirects to sign in page if bad email and password combo" do
    visit '/'
    fill_in 'session_email', with: 'd.jachimik@neu.edu'
    fill_in 'session_password', with: 'passord'
    click_button 'Sign in'
    page.current_path.must_equal '/'
    page.text.must_include 'bad email and password combintion. try again.'
  end

  it "allows user to sign out" do
    test_sign_in_admin
    click_link 'Sign out'
    page.current_path.must_equal '/'
    visit '/notifications'
    page.current_path.must_equal '/'
    page.text.must_include 'please sign in to go to there.'
  end
end
