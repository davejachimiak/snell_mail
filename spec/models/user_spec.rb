require 'spec_helper'
require_relative '../../app/models/user.rb'

describe "User" do
  describe "new object" do
	it "attributes should be nil" do
	  it = User.new
      it.name.must_be_nil
	  it.email.must_be_nil
	  it.encrypted_password.must_be_nil
	  it.admin.must_be_nil
    end
  end
  
  describe "password attribute" do
    it "is a accessorable" do
	  it = User.new
	  it.password.must_be_nil
	end
  end
  
  describe "validators" do
    describe "name" do
	  it "rejects a name under three characters" do
	    it = Factory(:user)
	    it.name = 'fo'
		it.wont_save
	  end
	end
  end
end