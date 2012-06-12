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
      @it = Factory(:user)
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
    it "is responsive to User object" do
      it = User.new
      it.must_respond_to :encrypt_password
    end

    it "saves the user's salt" do
      it = Factory(:user)
      it.encrypt_password
      it.salt.wont_be_nil
    end

    it "saves the encrypted password with salt" do
      it = Factory(:user)
      it.encrypt_password
      it.encrypted_password.must_equal Digest::SHA2.digest("#{it.password}#{it.salt}")
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
      time = Time.now
      @it.password = 'password'
      @it.make_salt.must_equal Digest::SHA2.digest("#{@it.password}#{Time.now}")
    end
  end

  describe "#authenticate" do
    it "is responsive to User object" do
      it = User
      it.must_respond_to :authenticate
    end

    it "returns true if email and password match a user in the db" do
      user = Factory(:user)
      User.create!(:name     => user.name,
                   :email    => user.email,
                   :password => user.password,
                   :admin    => user.admin)
      it = User.authenticate("#{user.email}", "#{user.password}")
      it.must_equal true
    end
  end
end
