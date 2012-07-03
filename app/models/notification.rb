class Notification < ActiveRecord::Base
  validates_presence_of :cohabitants, :message => "must be chosen"
  validates_presence_of :user

  belongs_to :user
  has_and_belongs_to_many :cohabitants
end
