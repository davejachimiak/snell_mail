class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :admin,
                  :notifications, :wants_update

  has_secure_password

  validates :name,     format: { with: SnellMail::Validators.name }
  validates :email,    format: { with: SnellMail::Validators.email }
  validates :password, length: { minimum: 7 }, allow_nil: true

  has_many :notifications
end
