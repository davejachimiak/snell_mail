require 'spec_helper'
require_relative '../../app/models/user.rb'

describe "User" do
  describe "new object" do
    before do
      @it = User.new
    end
	
    it "attributes should be nil" do
      @it.name.must_be_nil
      @it.email.must_be_nil
      @it.password_digest.must_be_nil
      @it.admin.must_be_nil
    end
	
    it "saves with password_digest if everything validates" do
      @it.name                  = 'Dave Jachimiak'
      @it.email                 = 'd.jachimiak@neu.edu'
      @it.password              = 'password'
      @it.password_confirmation = 'password'
	  
      @it.save.must_equal true
      @it.password_digest.wont_be_nil
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
	  before do
        @it = FactoryGirl.build(:user)
      end

      after do
        @it.save.wont_equal true
      end
	  
      it "rejects a name under two characters" do
	    @it.name = 'f'
      end

      it "rejects a name with no spaces" do
        @it.name = 'Dave'
      end

      it "rejects a name with more than three spaces" do
        @it.name = 'Dave poop fest mcggee'
      end
    end
	
	before do
      @it = FactoryGirl.build(:user)
    end

    after do
      @it.save.wont_equal true
    end

    describe "email" do
      it "must be valid email format" do
        @it.email = 'djachimiakskiatfart.narc'
      end      
    end

    describe "password" do
      it "must be more than 6 characters" do
        @it.password = 'joord'
      end
    end
  end
end
