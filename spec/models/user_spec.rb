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
end

