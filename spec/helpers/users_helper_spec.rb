require 'spec_helper'

describe UsersHelper do
  let(:user) { Factory(:user) }
  let(:non_admin) { Factory(:non_admin) }

  it '::user_email is responsive' do
    self.must_respond_to :user_email
  end
  
  it '::user_email returns mail to link if not current user' do
    it = user_email(non_admin, user.id)
    it.must_equal(mail_to non_admin.email)
  end
  
  it '::user_email returns string of email address if current user' do
    it = user_email(user, user.id)
    it.must_equal user.email
  end
end