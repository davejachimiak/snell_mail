class Cohabitant < ActiveRecord::Base
  validates_presence_of :department, :location, :contact_name, :contact_email
  validates :contact_email, format: { with: User::VALID_EMAIL_REGEX }

  attr_accessible :department, :location, :contact_name, :contact_email

  has_and_belongs_to_many :notifications
end
