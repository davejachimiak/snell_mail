require 'spec_helper'
include SessionsHelper
include ShowMeTheCookies

describe 'SessionsHelper' do
  describe '#sign_in Helper' do
    it "should be responsive on SessionsHelper" do
      it = SessionsHelper
      it.must_respond_to :sign_in
    end
	
    it "should send a cookie of the id and salt to the user's browser" do
      Factory(:user)
      sign_in user
      response.get '/'.must_include 'cookie'
    end
  end

  describe '#signed_in? Helper' do
    it 'checks to see if user is signed in' do
      skip
      user = Factory(:user)
      sign_in user
      it = params[:remember_token].signed_in?
      it.must_equal true
    end
  end
end
