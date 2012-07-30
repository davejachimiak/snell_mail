require 'spec_helper'

describe 'admin user cohabitant management integration' do
  let(:admin) { User.find_by_email('d.jachimiak@neu.edu') }
  let(:non_admin) { User.find_by_email('new.student@neu.edu') }

  before do
    create_test_users
    cohabitant   = Factory(:cohabitant)
    cohabitant_4 = Factory(:cohabitant_4)
    Factory(:notify_c1, user: admin, cohabitants: [cohabitant])
    Factory(:notify_c1_and_c4, user: non_admin, 
            cohabitants: [cohabitant, cohabitant_4])
  end

  after do
    %w(User Cohabitant Notification).each do |model_string|
      model = Kernel.const_get(model_string)
      model.all.each { |m| m.destroy } if model.any?
    end
  end

  describe 'non selenium' do
    after do
      reset_session!
    end

    describe 'no prep' do
      before do
        test_sign_in_admin
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
        page.text.must_include 'cool.lady@neu.edu'
        click_button 'Edit EdTech'
        fill_in 'cohabitant_location', with: '259SL'
        fill_in 'cohabitant_contact_name', with: 'Cool Person'
        fill_in 'cohabitant_contact_email', with: 'cool.person@neu.edu'
        click_button 'Edit'
        page.current_path.must_equal '/cohabitants'
        page.text.wont_include 'cool.fade@neu.edu'
        page.text.must_include 'cool.person@neu.edu'
      end

      it "shows all notifications for a given cohabitant" do
        click_link 'Cohabitants'
        click_link 'Cool Factory'
        page.text.must_include Time.zone.now.strftime('%A, %B %e %Y')
        page.text.must_include "Dave Jachimiak"
        page.text.must_include "New Student"
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

      it "allows admin users to deactivate cohabitants" do
        click_link 'Cohabitants'
        click_button 'Deactivate Cool Factory'
        cohabitant = Cohabitant.find_by_department('Cool Factory')
        cohabitant.activated?.must_equal false
        page.text.must_include 'Cool Factory deactivated.'
        click_link 'Cool Factory'
        page.text.must_include "(deactivated)"
      end
    end

    describe "cohabitants" do
      it "shows a friendly message if there are no active cohabitants " +
          "and are able to be reactivated" do
        Cohabitant.all.each { |cohabitant| cohabitant.update_attributes(activated: false) }
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

    describe "notifications" do
      it "gives a friendly message if a cohabitant has no notifications" do
        Notification.all.each { |notification| notification.destroy }
        test_sign_in_admin

        click_link 'Cohabitants'
        click_link 'Cool Factory'
        page.text.must_include 'Cool Factory has never been notified.'
      end
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
