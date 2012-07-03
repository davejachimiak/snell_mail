class Notification < ActiveRecord::Base
  validates_presence_of :cohabitants, :user
  
  belongs_to :user
  has_and_belongs_to_many :cohabitants
end