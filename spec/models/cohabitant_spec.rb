require 'spec_helper'
require_relative '../../app/models/cohabitant.rb'

describe "Cohabitant" do
  describe "new object" do
    before do
      @it = Cohabitant.new
    end
	
    it "attributes should be nil" do
      @it.department.must_be_nil
      @it.location.must_be_nil
      @it.contact_name.must_be_nil
      @it.contact_email.must_be_nil
    end
	
    it "saves if everything validates" do
      @it.department    = 'EdTech'
      @it.location      = '242SL'
      @it.contact_name  = 'Cool Guy'
      @it.contact_email = 'cool.guy@email.com'
	  
      @it.save.must_equal true
    end
  end
  
  describe "notifications association" do
    before do
      @it = FactoryGirl.create(:cohabitant)
      
      FactoryGirl.create(:notify_c1, 
        :user => FactoryGirl.create(:user),
        :cohabitants => [@it])
      FactoryGirl.create(:notify_c1_and_c4, 
        :user => FactoryGirl.create(:non_admin),
        :cohabitants => [@it, FactoryGirl.create(:cohabitant_4)])
    end
    
    it "has many notifications" do
      @it.notifications.count.must_equal 2
      @it.notifications[0].user.name.must_equal 'Dave Jachimiak'
      @it.notifications[1].user.name.must_equal 'New Student'
    end
  end
  
  describe "validators" do
    before do
      @it = FactoryGirl.build(:cohabitant)
    end

    after do
      @it.save.wont_equal true
    end

    it "won't save with blank department" do
      @it.department = ''
    end
	
    it "won't save with blank location" do
      @it.location = ''
    end
	
    it "won't save with blank contact_name" do
      @it.contact_name = ''
    end
	
    it "won't save with blank contact_email" do
      @it.contact_email = ''
    end
  end

  describe "::parse_for_notification" do
    before do
      @it = Cohabitant
    end
    
    before do
      Cohabitant.all.each { |cohabitant| cohabitant.destroy }
    end

    it "is responsive on the class" do
      @it.must_respond_to :parse_for_notification
    end

    it "presents necessary text for two cohabitants" do
      cohabitants = [FactoryGirl.create(:cohabitant)]
      @it.parse_for_notification(cohabitants).must_equal(
        'Cool Factory was ')
    end

    it "presents necessary text for two cohabitants" do
      cohabitants = [FactoryGirl.create(:cohabitant),
                     FactoryGirl.create(:cohabitant_3)]
      @it.parse_for_notification(cohabitants).must_equal(
        'Cool Factory and Face Surgery were ')
    end

    it "presents necessary text for three cohabitants" do
      cohabitants = [FactoryGirl.create(:cohabitant),
                     FactoryGirl.create(:cohabitant_2),
                     FactoryGirl.create(:cohabitant_3)]
      @it.parse_for_notification(cohabitants).must_equal(
        'Cool Factory, Jargon House, and Face Surgery were ')
    end
  end
end
