require 'spec_helper'

describe 'admin user user management integration' do
  let(:admin) { User.find_by_email('d.jachimiak@neu.edu') }
  let(:cohabitant) { Factory(:cohabitant) }
  let(:cohabitant_4) { Factory(:cohabitant_4) }

  before do
    Factory(:user, wants_update: false)
    Factory(:non_admin)
  end

  after do
    %w(User Cohabitant Notification).each do |model_string|
      model = Kernel.const_get(model_string)
      model.destroy_all if model.any?
    end
  end

  describe 'non-selenium integration' do
    before do
      test_sign_in_admin
    end

    after do
      reset_session!
    end

    it "allows admin users to create other and switch users to admin users" do
      click_link 'Users'
      click_button 'Edit New Student'
      fill_in 'user_email', with: 'old.student@neu.edu'
      check 'Admin'
      click_button 'Save'
      page.current_path.must_equal '/users'
      page.text.must_include 'old.student@neu.edu'
    end

    it "show all notifications for a given user" do
      notification_1 = Factory(:notification, user: admin, cohabitants: [cohabitant])
      notification_2 = Factory(:notification, user: admin, cohabitants: [cohabitant, cohabitant_4])

      click_link 'Users'
      click_link 'Dave Jachimiak'
      page.text.must_include notification_1.created_at.
        strftime('%m.%d.%Y (%A) at %I:%M%P')
      page.text.must_include notification_2.created_at.
        strftime('%m.%d.%Y (%A) at %I:%M%P')
    end

    describe "creates user" do
      let(:user_wants_update) {  User.find_by_email('happy.bobappy@example.com').wants_update }

      before do
        Factory(:cohabitant)
        click_link 'Users'
        click_link 'New user'
        fill_in 'user_name', with: 'Happy Bobappy'
        fill_in 'user_email', with: 'happy.bobappy@example.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
      end

      it "and redirects to user index after admin creates user" do
        click_button 'Create'
        page.text.must_include 'Happy Bobappy'
        page.text.must_include 'happy.bobappy@example.com'
      end

      it "and allows admin users to create and edit admin users that " +
        "want to be updated when there's a notification" do
        page.text.wont_include 'wants update'
        check 'Admin'
        page.has_checked_field?('Wants update').must_equal true
        click_button 'Create'
        user_wants_update.must_equal true
        click_button 'Edit Happy Bobappy'
        uncheck 'Admin'
        page.has_selector?('Wants update').must_equal false
        check 'Admin'
        uncheck 'Wants update'
        click_button 'Save'
        click_link 'Notifications'
        click_link 'New notification'
        check 'Cool Factory'
        click_button 'Notify!'
        ActionMailer::Base.deliveries.last.to.wont_include 'happy.bobappy@example.com'
      end
    end
  end

  it "allows admin users to destroy other's but doesn't not allow " +
     "admin users to destroy themselves" do
    Capybara.current_driver = :selenium
    test_sign_in_admin

    click_link 'Users'
    click_button 'Delete New Student'
    page.driver.browser.switch_to.alert.accept
    page.current_path.must_equal '/users'
    page.text.wont_include 'New Student'
    page.body.wont_include 'Delete Dave Jachimiak'
    click_link 'Users'
    click_link 'New user'
    fill_in 'user_name', with: 'New Student'
    fill_in 'user_email', with: 'new.student@neu.edu'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    click_button 'Create'
    click_link 'Sign out'

    reset_session!
    Capybara.use_default_driver
  end
end
