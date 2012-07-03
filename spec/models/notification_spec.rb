require 'spec_helper'
require_relative '../../app/models/notification.rb'

describe "Notification" do
  describe "associations" do
    before do
      user = FactoryGirl.create(:user)
      cohabitants  = [FactoryGirl.create(:cohabitant), 
                      FactoryGirl.create(:cohabitant_2),
                      FactoryGirl.create(:cohabitant_4)]
      @notification = Notification.new(:user => user, :cohabitants => cohabitants)
    end
	
    it "belongs to cohabitants and a user" do
	    @notification.save.must_equal true
    end
	
    it "#cohabitants returns array" do
      @notification.cohabitants.must_be_instance_of Array
    end
    
    it "#user returns instance of User" do
      @notification.user.must_be_instance_of User
    end
  end
  
  describe "validators" do
    before do
      user = FactoryGirl.create(:user)
      cohabitant = FactoryGirl.create(:cohabitant)
      @notification = Notification.new(:user_id => user.id, :cohabitant_ids => 
                                       [cohabitant.id])
    end
    
    after do
      @notification.save.wont_equal true
    end
    
    it "won't save if no cohabitants" do
      @notification.cohabitant_ids = nil
    end
    
    it "won't save if no users" do
      @notification.user_id = nil
    end
  end
end

