class Notification < ActiveRecord::Base
  validates_presence_of :cohabitants, message: "must be chosen"
  validates_presence_of :user

  attr_accessible :user, :user_id, :cohabitants, :cohabitant_ids
  attr_readonly :created_at

  belongs_to :user
  has_and_belongs_to_many :cohabitants

  delegate :name, :email, to: :user, prefix: true
end
