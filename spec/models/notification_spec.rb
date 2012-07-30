require 'spec_helper'
require_relative '../../app/models/notification.rb'

describe "Notification" do
  describe "associations" do
    let(:notification) { Notification.new(user: @user, cohabitants: @cohabitants) }

    before do
      @user = Factory(:user)
      @cohabitants = [Factory(:cohabitant), 
                      Factory(:cohabitant_2),
                      Factory(:cohabitant_4)]
    end

    it "belongs to cohabitants and a user" do
      notification.save.must_equal true
    end
	
    it "#cohabitants returns array" do
      notification.cohabitants.must_be_instance_of Array
    end
    
    it "#user returns instance of User" do
      notification.user.must_be_instance_of User
    end
    
    it "delegates user attributes" do
      notification.user_name.must_equal 'Dave Jachimiak'
      notification.user_email.must_equal 'd.jachimiak@neu.edu'
    end
  end
  
  describe "validators" do
    let(:notification) { Notification.new(user_id: @user.id, cohabitant_ids: [@cohabitant.id]) }

    before do
      @user = FactoryGirl.create(:user)
      @cohabitant = FactoryGirl.create(:cohabitant)
    end
    
    after do
      notification.save.wont_equal true
    end

    it "won't save if no cohabitants" do
      notification.cohabitant_ids = nil
    end
    
    it "won't save if no users" do
      notification.user_id = nil
    end
  end
end
