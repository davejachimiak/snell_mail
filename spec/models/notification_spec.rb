require 'spec_helper'
require_relative '../../app/models/notification.rb'

describe "Notification" do
  subject { Notification.new }

  it_must { allow_mass_assignment_of :cohabitants }
  it_must { allow_mass_assignment_of :user }
  it_must { allow_mass_assignment_of :cohabitant_ids }
  it_must { allow_mass_assignment_of :user_id }
  it_must { have_readonly_attribute  :created_at }

  it_must { have_and_belong_to_many :cohabitants }
  it_must { belong_to :user }

  it_must { validate_presence_of(:cohabitants).with_message(/must be chosen/) }
  it_must { validate_presence_of(:user) }

  describe "delegates user attributes" do
    subject { Notification.new }
  
    it { subject.must_respond_to :user_name }
    it { subject.must_respond_to :user_email }
  end

  describe "#cohabitants_departments" do
    before { @notification = Factory(:notification_with_cohabitant) }

    after do
      %w(Notification Cohabitant).each do |model_string|
        model = Kernel.const_get(model_string)
        model.destroy_all
      end
    end

    describe 'has cohabitants' do
      it "returns departments of given cohabitants" do
        @notification.cohabitants_departments.must_include 'Cool Factory'
      end
    end
  end
end
