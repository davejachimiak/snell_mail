class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :admin,
                  :wants_update
  attr_readonly   :notifications

  has_secure_password

  validates :name,     format: { with: SnellMail::Validators.name }
  validates :email,    format: { with: SnellMail::Validators.email }
  validates :password, length: { minimum: 7 }, allow_nil: true

  has_many :notifications
  
  def self.want_update
    all.select { |user| user.wants_update? }
  end
end
