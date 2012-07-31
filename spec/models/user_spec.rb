require 'spec_helper'
require_relative '../../app/models/user.rb'

describe "User" do
  describe "new object" do
    let(:user) { User.new }
	
    it "attributes should be nil" do
      user.name.must_be_nil
      user.email.must_be_nil
      user.password_digest.must_be_nil
      user.admin.must_be_nil
    end
	
    it "saves with password_digest if everything validates" do
      user.name                  = 'Dave Jachimiak'
      user.email                 = 'd.jachimiak@neu.edu'
      user.password              = 'password'
      user.password_confirmation = 'password'
	  
      user.save.must_equal true
      user.password_digest.wont_be_nil
    end
  end
  
  describe "validators" do
    let(:user) { FactoryGirl.build(:user) }
    
    describe "name" do

      after do
        user.save.wont_equal true
      end
	  
      it "rejects a name under two characters" do
	      user.name = 'f'
      end

      it "rejects a name with no spaces" do
        user.name = 'Dave'
      end

      it "rejects a name with more than three spaces" do
        user.name = 'Dave poop fest mcggee'
      end
    end

    describe "email" do
      it "must be valid email format" do
        user.email = 'djachimiakskiatfart.narc'
        user.save.wont_equal true
      end      
    end

    describe "password" do
      it "must be more than 6 characters" do
        user.password = 'joord'
        user.save.wont_equal true
      end
    end
  end
  
  describe "notifications association" do
    it "has many notifications" do
      cohabitant = Factory(:cohabitant)
      user = Factory(:non_admin)

      notification_1 = Factory(:notify_c1, 
        user: user,
        cohabitants: [cohabitant])
      notification_2 = Factory(:notify_c1_and_c4,
        user: user,
        cohabitants: [cohabitant, Factory(:cohabitant_4)])

      user.notifications.count.must_equal 2
      user.notifications[0].created_at.must_equal notification_1.created_at
      user.notifications[1].created_at.must_equal notification_2.created_at
    end
  end
end

