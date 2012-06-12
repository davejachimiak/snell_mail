class User < ActiveRecord::Base
  VALID_NAME_REGEX  = /\A([a-zA-Z]){2,} (([a-zA-Z]){2,}|([a-zA-Z]){2,} ([a-zA-Z]){2,})\z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  attr_accessor :password

  validates :name,     :format => { :with => VALID_NAME_REGEX }
  validates :email,    :format => { :with => VALID_EMAIL_REGEX }
  validates :password, :length => { :minimum => 7 }
  
  before_save :encrypt_password

  class << self
    def authenticate(email, password)
      user = find_by_email(email)
      user.encrypted_password == Digest::SHA2.digest("#{password}#{user.salt}")
    end
  end

  def encrypt_password
    self.salt = make_salt
    self.encrypted_password = Digest::SHA2.digest("#{password}#{salt}")
  end

  def make_salt
    Digest::SHA2.digest("#{password}#{Time.now}")
  end
end
