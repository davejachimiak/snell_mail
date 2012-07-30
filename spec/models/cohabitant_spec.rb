require 'spec_helper'
require_relative '../../app/models/cohabitant.rb'

describe "Cohabitant" do
  describe "new object" do
    let(:cohabitant) { Cohabitant.new }

    it "attributes should be nil" do
      cohabitant.department.must_be_nil
      cohabitant.location.must_be_nil
      cohabitant.contact_name.must_be_nil
      cohabitant.contact_email.must_be_nil
    end
	
    it "saves if everything validates" do
      cohabitant.department    = 'EdTech'
      cohabitant.location      = '242SL'
      cohabitant.contact_name  = 'Cool Guy'
      cohabitant.contact_email = 'cool.guy@email.com'
	  
      cohabitant.save.must_equal true
    end
  end
  
  describe "notifications association" do
    let(:cohabitant) { Factory(:cohabitant) }
    let(:cohabitant_4) { Factory(:cohabitant_4) }

    before do
      Factory(:notify_c1, 
        user: Factory(:user),
        cohabitants: [cohabitant])
      Factory(:notify_c1_and_c4, 
        user: Factory(:non_admin),
        cohabitants: [cohabitant, cohabitant_4])
    end

    it "has many notifications" do
      cohabitant.notifications.count.must_equal 2
      cohabitant.notifications[0].user.name.must_equal 'Dave Jachimiak'
      cohabitant.notifications[1].user.name.must_equal 'New Student'
    end
  end

  describe "validators" do
    let(:cohabitant) { FactoryGirl.build(:cohabitant) }

    after do
      cohabitant.save.wont_equal true
    end

    it "won't save with blank department" do
      cohabitant.department = ''
    end
	
    it "won't save with blank location" do
      cohabitant.location = ''
    end
	
    it "won't save with blank contact_name" do
      cohabitant.contact_name = ''
    end

    it "won't save with an invalid name" do
      cohabitant.contact_name = 'Si'
    end
	
    it "won't save with blank contact_email" do
      cohabitant.contact_email = ''
    end
  end

  describe "#toggle_activated!" do
    let(:cohabitant) { Factory(:cohabitant) }

    it "is responsive" do
      cohabitant.must_respond_to :toggle_activated!
    end

    it "toggles activated attribute" do
      cohabitant.toggle_activated!
      cohabitant.activated.must_equal false

      cohabitant.toggle_activated!
      cohabitant.activated.must_equal true
    end
    
    it "returns flash value" do
      cohabitant.toggle_activated![:flash].must_equal 'info'
      cohabitant.toggle_activated![:flash].must_equal 'success'
    end
    
    it "returns adjetive" do
      cohabitant.toggle_activated![:adj].must_equal 'deactivated'
      cohabitant.toggle_activated![:adj].must_equal 'reactivated'
    end
  end
end
