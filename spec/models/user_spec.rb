require 'spec_helper'
require_relative '../../app/models/user.rb'

describe "User" do
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

    after do
      User.all.each { |user| user.destroy }
    end

    it { subject.first.email.must_equal 'd.jachimiak@neu.edu' }
    it { subject.last.email.must_equal 'dave.jachimiak@gmail.com' }
    it { subject.map { |user| user.email }.wont_include 'new.student@neu.edu' }
  end
end

