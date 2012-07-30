require 'spec_helper'

describe 'non admin user integration' do
  before do
    create_test_users
  end

  after do
    %w(User Cohabitant Notification).each do |model_string|
      model = Kernel.const_get(model_string)
      model.all.each { |m| m.destroy } if model.any?
    end

    reset_session!
  end

  describe 'with no db prep' do
    before do
      test_sign_in_non_admin
    end

    it "shows a friendly message if there are no active cohabitants (non_admin)" do
      page.text.must_include 'There are no active cohabitants to notify. ' +
                             'Please tell your supervisor to add them.'
    end

    it "allows only admin users to resource users or cohabitants" do
      page.text.wont_include 'Cohabitants'
      page.text.wont_include 'Users'
      visit '/cohabitants'
      page.current_path.must_equal '/notifications'
      page.text.must_include 'Only admin users can go to there.'
      visit '/users'
      page.current_path.must_equal '/notifications'
      page.text.must_include 'Only admin users can go to there.'
    end
  end
end
