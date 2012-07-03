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
end
