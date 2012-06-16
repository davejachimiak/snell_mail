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
    before do
      @it = FactoryGirl.build(:user)
    end

    after do
      @it.save.wont_equal true
    end
    
    describe "name" do
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

  describe "#encrypt_password" do
    before do
      @it = FactoryGirl.build(:user)
      @it.encrypt_password
    end
    
    it "is responsive to User object" do
      it = User.new
      it.must_respond_to :encrypt_password
    end

    it "saves the user's salt" do
      @it.salt.wont_be_nil
    end

    it "saves the encrypted password with salt" do
      @it.encrypted_password.must_equal Digest::SHA2.digest("#{@it.password}#{@it.salt}")
    end
  end

  describe "#make_salt" do
    before do
      @it = User.new
    end
    it "is responsive to User object" do
      @it.must_respond_to :make_salt
    end
    
    it "makes an SHA2 hash of the current time and password" do
      @it.password = 'password'
      @it.make_salt.must_equal Digest::SHA2.digest("#{@it.password}#{Time.now}")
    end
  end

  describe "#authenticate" do
    before do
      @user = FactoryGirl.create(:user)
    end
    
    it "is responsive to User object" do
      it = User
      it.must_respond_to :authenticate
    end

    it "returns user hash if email and password match a user in the db" do
      it = User.authenticate(@user.email, @user.password)
      it.must_equal User.find_by_email(@user.email)
    end
	
    it "returns false if email doesn't exist in db" do
      it = User.authenticate('d.jachimia@neu.edu', @user.password)
      it.wont_equal true
    end
	
    it "returns false if password doesn't match email's user" do
      it = User.authenticate(@user.email, 'passwor')
      it.wont_equal true
    end
  end

  describe "#password_confirmation" do
    it "is responsive on User instance" do
      it = User.new
      it.must_respond_to :password_confirmation
    end
  end

  describe "#old_password" do
    it "is responsive on User instance" do
      it = User.new
      it.must_respond_to :old_password
    end
  end
end
