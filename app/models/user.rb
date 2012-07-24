class User < ActiveRecord::Base
  VALID_NAME_REGEX  =
    /\A([a-zA-Z]){2,} (([a-zA-Z]){2,}|([a-zA-Z]){2,} ([a-zA-Z]){2,})\z/

  attr_accessible :name, :email, :password, :password_confirmation, :admin,
                  :notifications

  has_secure_password

  validates :name,     format: { with: VALID_NAME_REGEX }
  validates :email,    format: { with: SnellMail::Validators.email }
  validates :password, length: { minimum: 7 }, allow_nil: true

  has_many :notifications
end
