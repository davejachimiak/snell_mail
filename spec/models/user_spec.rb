require 'spec_helper'
require_relative '../../app/models/user.rb'

describe "User" do
  after do
    User.destroy_all if User.any?
  end

  subject { User.new }

  it_must { allow_mass_assignment_of :name }
  it_must { allow_mass_assignment_of :email }
  it_must { allow_mass_assignment_of :password }
  it_must { allow_mass_assignment_of :password_confirmation }
  it_must { allow_mass_assignment_of :admin }
  it_must { allow_mass_assignment_of :wants_update }

  it_must { have_readonly_attribute :notifications }

  it_must { validate_format_of(:name).with("Cool Guy Plus") }
  it_must { validate_format_of(:name).not_with("SoCool") }
  it_must { validate_format_of(:email).with("cool.guy@neu.edu") }
  it_must { validate_format_of(:email).not_with("cool.guyneu.edu") }

  it_must { ensure_length_of(:password).is_at_least(7) }

  it_must { have_many :notifications }

  describe '::want_update' do
    subject { User.want_update }

    before do
      Factory(:user)
      Factory(:user, email: 'dave.jachimiak@gmail.com')
      Factory(:non_admin)
    end

    it { subject.first.email.must_equal 'd.jachimiak@neu.edu' }
    it { subject.last.email.must_equal 'dave.jachimiak@gmail.com' }
    it { subject.map { |user| user.email }.wont_include 'new.student@neu.edu' }
  end

  describe '::others_that_want_update_emails' do
    before do
      notifier = Factory(:user)
      Factory(:admin_no_update)
      Factory(:user, email: 'dave.jachimiak@gmail.com')

      @it = User.others_that_want_update_emails(notifier)
    end

    it "must include emails of admin users that want update" do
      @it.must_include('dave.jachimiak@gmail.com')
    end

    it "must not include emails of admin users that don't want update" do
      @it.wont_include('g.diaper@pamps.org')
    end

    it "won't include the email of the notifier" do
      @it.wont_include('d.jachimiak@neu.edu')
    end
  end
end

