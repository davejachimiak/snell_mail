require 'spec_helper'
require_relative '../../app/models/cohabitant.rb'

describe "Cohabitant model" do

  after do
    Cohabitant.destroy_all
  end

  subject { Cohabitant.new }

  it_must { have_and_belong_to_many :notifications }

  it_must { allow_mass_assignment_of :department }
  it_must { allow_mass_assignment_of :location }
  it_must { allow_mass_assignment_of :contact_name }
  it_must { allow_mass_assignment_of :contact_email }
  it_must { allow_mass_assignment_of :activated }

  it_must { validate_presence_of :department }
  it_must { validate_presence_of :location }
  it_must { validate_presence_of :contact_name }
  it_must { validate_presence_of :contact_email }

  it_must { validate_format_of(:contact_name).with("Cool Guy Plus") }
  it_must { validate_format_of(:contact_name).not_with("SoCool") }
  it_must { validate_format_of(:contact_email).with("cool.guy@neu.edu") }
  it_must { validate_format_of(:contact_email).not_with("cool.guyneu.edu") }

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
  end

  describe "::activated" do
    before do
      @activated_cohabitant = Factory(:activated_cohabitant)
      @deactivated_cohabitant = Factory(:deactivated_cohabitant)
    end

    it "returns activated cohabitants" do
      Cohabitant.activated.must_include @activated_cohabitant
    end

    it "doesn't return deactivated cohabitants" do
      Cohabitant.activated.wont_include @deactivated_cohabitant
    end
  end
end
