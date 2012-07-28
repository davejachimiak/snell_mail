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
        user: FactoryGirl.create(:user),
        cohabitants: [@it])
      FactoryGirl.create(:notify_c1_and_c4, 
        user: FactoryGirl.create(:non_admin),
        cohabitants: [@it, FactoryGirl.create(:cohabitant_4)])
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

    it "won't save with an invalid name" do
      @it.contact_name = 'Si'
    end
	
    it "won't save with blank contact_email" do
      @it.contact_email = ''
    end
  end

  describe "#toggle_activated!" do
    before do
      @it = FactoryGirl.create(:cohabitant)
    end

    it "is responsive" do
      @it.must_respond_to :toggle_activated!
    end

    it "toggles activated attribute" do
      @it.toggle_activated!
      @it.activated.must_equal false

      @it.toggle_activated!
      @it.activated.must_equal true
    end
    
    it "returns flash value" do
      @it.toggle_activated![:flash].must_equal 'info'
      @it.toggle_activated![:flash].must_equal 'success'
    end
    
    it "returns adjetive" do
      @it.toggle_activated![:adj].must_equal 'deactivated'
      @it.toggle_activated![:adj].must_equal 'reactivated'
    end
  end
end
