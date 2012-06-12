require 'spec_helper'
include SessionsHelper

describe 'SessionsHelper' do
  describe '#sign_in Helper' do
    it "should be responsive on SessionsHelper" do
	  it = SessionsHelper
	  it.must_respond_to :sign_in
	end
	
	it "should send a cookie of the id and salt to the user's browser" do
	  user = Factory(:user)
	  SessionsHelper.sign_in(user)
	  rack_test_driver = current_session.driver
	  cookie_jar = rack_test_driver.instance_variable_get(:@rack_mock_session).cookie_jar
	  cookie_jar.must_include 'remember_token'
	end
  end

  describe '#sign_in? Helper' do
    it 'checks to see if user is signed in' do
	  skip('wait for #sign_in tests')
	  user = Factory(:user)
	  params[:remember_token] = [user.id, user.salt]
	  it = params[:remember_token].signed_in?
	  it.must_equal true
	end
  end
end