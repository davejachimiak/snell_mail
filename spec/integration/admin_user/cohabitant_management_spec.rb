require 'spec_helper'

describe 'admin user cohabitant management integration' do
  let(:admin) { User.find_by_email('d.jachimiak@neu.edu') }
  let(:non_admin) { User.find_by_email('new.student@neu.edu') }

  before do
    create_test_users
  end

  after do
    %w(User Cohabitant Notification).each do |model_string|
      model = Kernel.const_get(model_string)
      model.destroy_all if model.any?
    end
  end

  describe 'no db prep' do
    before do
      test_sign_in_admin
    end

    after do
      reset_session!
    end

    it "should allow admin users to create and edit cohabitants" do
      click_link 'Cohabitants'
      click_link 'New cohabitant'
      fill_in 'cohabitant_department', with: 'EdTech'
      fill_in 'cohabitant_location', with: '242SL'
      fill_in 'cohabitant_contact_name', with: 'Cool Lady'
      fill_in 'cohabitant_contact_email', with: 'cool.fade@neu.edu'
      click_button 'Create'
      page.current_path.must_equal '/cohabitants'
      page.text.must_include 'EdTech'
      page.text.must_include '242SL'
      page.text.must_include 'Cool Lady'
      page.text.must_include 'cool.fade@neu.edu'
      click_button 'Edit EdTech'
      fill_in 'cohabitant_location', with: '259SL'
      fill_in 'cohabitant_contact_name', with: 'Cool Person'
      fill_in 'cohabitant_contact_email', with: 'cool.person@neu.edu'
      click_button 'Edit'
      page.current_path.must_equal '/cohabitants'
      page.text.wont_include 'cool.fade@neu.edu'
      page.text.must_include 'cool.person@neu.edu'
    end

    it "won't save new cohabitant if attributes are invalid" do
      inclusion_strings = ["department can't be blank",
                           "location can't be blank",
                           "contact name can't be blank",
                           "contact email can't be blank"]

      click_link 'Cohabitants'
      click_link 'New cohabitant'
      click_button 'Create'
      page.current_path.must_equal '/cohabitants'
      inclusion_strings.each { |string| page.text.must_include string }
      fill_in 'cohabitant_department', with: 'Cool Factory'
      fill_in 'cohabitant_location', with: '242SL'
      fill_in 'cohabitant_contact_name', with: 'Cool Lady'
      fill_in 'cohabitant_contact_email', with: 'cool.ladyneu.edu'
      click_button 'Create'
      page.text.must_include 'contact email is invalid'
    end
  end

  describe 'requires cohabitant' do
    before do
      Factory(:cohabitant)
    end

    describe 'non-selenium' do
      before do
        test_sign_in_admin
      end

      after do
        reset_session!
      end

      it "allows admin users to deactivate cohabitants" do
        click_link 'Cohabitants'
        click_button 'Deactivate Cool Factory'

        cohabitant = Cohabitant.find_by_department('Cool Factory')
        cohabitant.activated?.must_equal false

        page.text.must_include 'Cool Factory deactivated.'
        click_link 'Cool Factory'
        page.text.must_include "(deactivated)"
        reset_session!
      end

      it "gives a friendly message if a cohabitant has no notifications" do
        click_link 'Cohabitants'
        click_link 'Cool Factory'
        page.text.must_include 'Cool Factory has never been notified.'
      end
    end

    it "allows admin users to destroy cohabitants" do
      Capybara.current_driver = :selenium
      test_sign_in_admin

      click_link 'Cohabitants'
      click_button 'Delete Cool Factory'
      page.driver.browser.switch_to.alert.accept
      page.current_path.must_equal '/cohabitants'
      page.text.wont_include 'Cool Factory'

      reset_session!
      Capybara.current_driver = :rack_test
    end
  end

  describe 'particular prep per spec' do
    after do
      reset_session!
    end

    # needs a cohabitant with two notifications, one from each user 
    it "shows all notifications for a given cohabitant" do
      cohabitant = Factory(:cohabitant)
      Factory(:notification, cohabitants: [cohabitant])
      Factory(:notification_by_non_admin, cohabitants: [cohabitant])
      test_sign_in_admin
      click_link 'Cohabitants'
      click_link 'Cool Factory'
      page.text.must_include Time.zone.now.strftime('%A, %B %e %Y')
      page.text.must_include "Dave Jachimiak"
      page.text.must_include "New Student"
    end

    # needs deactivated cohabitant
    it "shows a friendly message if there are no active cohabitants " +
        "and are able to be reactivated" do
      Factory(:deactivated_cohabitant)

      test_sign_in_admin
      page.text.must_include 'There are no active cohabitants. Please activate or add them.'
      click_link 'Cohabitants'
      click_button 'Activate Cool Factory'
      page.text.must_include 'Cool Factory reactivated.'
      click_link 'Notifications'
      click_link 'New notification'
      page.text.must_include 'Cool Factory'
    end
  end
end
