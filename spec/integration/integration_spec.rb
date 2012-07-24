require 'spec_helper'

describe "integration" do
  after do
    %w(User Cohabitant Notification).each do |model_string|
      model = Kernel.const_get(model_string)
      model.all.each { |m| m.destroy } if model.any?
    end

    reset_session!
  end
  
  it "doesn't show header if you aren't signed in" do
    visit '/'
    page.text.wont_include 'Users'
  end
  
  it "doesn't allow non-signed in users to visit sensitive paths" do
    visit '/users'
    page.current_path.must_equal '/'
    page.text.must_include 'please sign in to go to there.'
    visit '/notifications'
    page.current_path.must_equal '/'
    page.text.must_include 'please sign in to go to there.'
    visit '/cohabitants'
    page.current_path.must_equal '/'
    page.text.must_include 'please sign in to go to there.'
  end

  describe "users integration" do
    before do
      create_test_users
    end

    it "redirects to sign in page if bad email and password combo" do
      visit '/'
      fill_in 'session_email', with: 'd.jachimik@neu.edu'
      fill_in 'session_password', with: 'passord'
      click_button 'Sign in'
      page.current_path.must_equal '/'
      page.text.must_include 'bad email and password combintion. try again.'
    end
    
    describe "sign in non admin integration" do
      before do
        test_sign_in_non_admin
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
      
      it "allows any user to change their password" do
        click_link 'Change password'
        fill_in 'Old password', with: 'password'
        fill_in 'New password', with: 'passwordpassword'
        fill_in 'New password again', with: 'passwordpassword'
        click_button 'Change password'
        page.current_path.must_equal '/notifications/new'
        page.text.must_include 'new password saved!'
        click_link 'Sign out'
        fill_in 'session_email', with: 'new.student@neu.edu'
        fill_in 'session_password', with: 'password'
        click_button 'Sign in'
        page.text.must_include 'bad email and password combintion. try again.'
        fill_in 'session_email', with: 'new.student@neu.edu'
        fill_in 'session_password', with: 'passwordpassword'
        click_button 'Sign in'
        page.current_path.must_equal '/notifications/new'
        click_link 'Sign out'
        fill_in 'session_email', with: 'd.jachimiak@neu.edu'
        fill_in 'session_password', with: 'password'
        click_button 'Sign in'
        click_link 'Users'
        click_button 'Edit Dave Jachimiak'
        click_link 'Change password'
        fill_in 'Old password', with: 'password'
        fill_in 'New password', with: 'passwordpassword'
        fill_in 'New password again', with: 'passwordpassword'
        click_button 'Change password'
        id = User.find_by_email('d.jachimiak@neu.edu').id
        page.current_path.must_equal "/users/#{id}/edit"
        page.text.must_include 'new password saved!'
      end
    end

    describe "sign in admin integration" do
      before do
        test_sign_in_admin
      end

      it "allows user to sign out" do
        click_link 'Sign out'
        page.current_path.must_equal '/'
        visit '/notifications'
        page.current_path.must_equal '/'
        page.text.must_include 'please sign in to go to there.'
      end
      
      it "should allow admin users to create and edit cohabitants" do
        click_link 'Cohabitants'
        click_link 'New cohabitant'
        fill_in 'cohabitant_department', with: 'EdTech'
        fill_in 'cohabitant_location', with: '242SL'
        fill_in 'cohabitant_contact_name', with: 'Cool Lady'
        fill_in 'cohabitant_contact_email', with: 'cool.lady@neu.edu'
        click_button 'Create'
        page.current_path.must_equal '/cohabitants'
        page.text.must_include 'EdTech'
        page.text.must_include '242SL'
        page.text.must_include 'Cool Lady'
        page.text.must_include 'cool.lady@neu.edu'
        click_button 'Edit EdTech'
        fill_in 'cohabitant_location', with: '259SL'
        fill_in 'cohabitant_contact_name', with: 'Cool Dude'
        fill_in 'cohabitant_contact_email', with: 'cool.dude@neu.edu'
        click_button 'Edit'
        page.current_path.must_equal '/cohabitants'
        page.text.wont_include 'cool.lady@neu.edu'
        page.text.must_include 'cool.dude@neu.edu'
      end
      
      it "won't save new cohabitant" do
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

      describe "click Users integration" do
        before do
          click_link 'Users'
        end

        it "allows admin users to create other and switch users " +
           "to admin users" do
          click_button 'Edit New Student'
          fill_in 'user_email', with: 'old.student@neu.edu'
          check 'Admin'
          click_button 'Save'
          page.current_path.must_equal '/users'
          page.text.must_include 'old.student@neu.edu'
          User.find_by_email('old.student@neu.edu').
            update_attributes(email: 'new.student@neu.edu',
                              admin: false)
        end

        it "redirects to user index after admin creates user" do
          click_link 'New user'
          fill_in 'user_name', with: 'Happy Bobappy'
          fill_in 'user_email', with: 'happy.bobappy@example.com'
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button 'Create'
          page.text.must_include 'Happy Bobappy'
          page.text.must_include 'happy.bobappy@example.com'
        end
      end
    end
    
    describe "one cohabitant integration" do
      before do
        @cohabitant = FactoryGirl.create(:cohabitant)
      end
      
      it "deactivated cohabitants won't show up new notification list " +
         "and can be reactivated" do
        Cohabitant.find_by_department('Cool Factory').
          update_attributes(activated: false)
        
        test_sign_in_admin
        page.text.wont_include 'Cool Factory'
        click_link 'Cohabitants'
        click_button 'Activate Cool Factory'
        page.text.must_include 'Cool Factory reactivated.'
        cohabitant = Cohabitant.find_by_department('Cool Factory')
        click_link 'Notifications'
        click_link 'New notification'
        page.text.must_include 'Cool Factory'
      end

      describe "sign in admin integration" do
        before do
          test_sign_in_admin
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
        	
        it "shouldn't save notification if no cohabitants are present" do
          click_button 'Notify!'
          page.current_path.must_equal '/notifications'
          page.text.must_include "Check each cohabitant that has mail " +
                                 "in their bin."
          page.text.must_include 'cohabitants must be chosen'
        end

        it "should singularize confirmation notice " +
           "for single cohabitant notifications" do
          check 'Cool Factory'
          click_button 'Notify!'
          page.text.must_include 'Cool Factory was'
        end
        
        it "gives a friendly message if a cohabitant has no notifications" do
          click_link 'Cohabitants'
          click_link 'Cool Factory'
          page.text.must_include 'Cool Factory has never been notified.'
        end
      end
      
      describe "two cohabitants integration" do
        before do
          @admin = User.find_by_email('d.jachimiak@neu.edu')
        
          @cohabitant_4 = FactoryGirl.create(:cohabitant_4)
          
          @notification_1 = FactoryGirl.create(:notify_c1, user: @admin, 
                              cohabitants: [@cohabitant])
        end
        
        describe "one notification by non admin integration" do
          before do
            @non_admin = User.find_by_email('new.student@neu.edu')
          end

          describe "sign in integration" do
            before do
              test_sign_in_admin
            end
            
            it "show all notifications for a given user" do
              notification_2 = FactoryGirl.create(:notify_c1_and_c4,
                user: @admin, cohabitants: [@cohabitant, @cohabitant_4])

              click_link 'Users'
              click_link 'Dave Jachimiak'
              page.text.must_include @notification_1.created_at.
                strftime('%m.%d.%Y (%A) at %I:%M%P')
              page.text.must_include notification_2.created_at.
                strftime('%m.%d.%Y (%A) at %I:%M%P')
            end
            
          end
          
          describe "two notification by both users sign in integration" do
            before do
              @notification_2 = FactoryGirl.create(
                                  :notify_c1_and_c4,
                                  user: @non_admin,
                                  cohabitants: [@cohabitant, @cohabitant_4]
                                                  )
            end
            
            it "should indicate that a deleted user made a notification" do
              User.destroy(@non_admin.id)
              test_sign_in_admin

              click_link 'Notifications'
              page.text.must_include 'deleted user'
              click_link 'Cohabitants'
              click_link 'Cool Factory'
              page.text.must_include Time.zone.now.strftime('%A, %B %e %Y')
              page.text.must_include 'deleted user'
            end

            it "should notify cohabitants that they have mail " +
               "and redirect to notifications after notification" do
              FactoryGirl.create(:cohabitant_2)
              FactoryGirl.create(:cohabitant_3)
              @time = Time.now
              test_sign_in_admin
            
              page.text.must_include "New notification " +
                                     "for #{@time.strftime("%A, %B %e, %Y")}"
              page.text.must_include "Check each cohabitant " +
                                     "that has mail in their bin."
              check 'Cool Factory'
              check 'Jargon House'
              check 'Face Surgery'
              check 'Fun Section'
              click_button 'Notify!'
              page.current_path.must_equal '/notifications'
              page.text.must_include 'Cool Factory, Fun Section, Jargon House, ' +
                                     'and Face Surgery were just notified ' +
                                     'that they have mail ' +
                                     'in their bins today. Thanks.'
            end
            
            describe "sign in integration" do
              before do
                test_sign_in_admin
              end
              
              it "shows all notifications for a given cohabitant" do
                click_link 'Cohabitants'
                click_link 'Cool Factory'
                page.text.must_include Time.zone.now.strftime('%A, %B %e %Y')
                page.text.must_include "Dave Jachimiak"
                page.text.must_include "New Student"
              end
              
              it "should tell of all cohabitants for a given notification." do
                ns_notification_link = @notification_2.created_at.
                                         strftime('%m.%d.%Y (%A) at %I:%M%P')

                click_link 'Notifications'
                page.text.must_include @notification_1.created_at.
                  strftime('%m.%d.%Y (%A) at %I:%M%P')
                page.text.must_include ns_notification_link
                click_link ns_notification_link
                @notification_2.cohabitants.each do |c| 
                  page.text.must_include c.department
                end
              end
            end
          end
        end
      end
    end
  end

  # describe "selenium integration" do
    # before do
      # create_test_users
      # Capybara.current_driver = :selenium
    # end

    # after do
      # Capybara.current_driver = :rack_test
    # end

    # it "allows admin users to destroy other's but doesn't not allow " +
       # "admin users to destroy themselves" do
       # test_sign_in_admin
       
       # click_link 'Users'
       # click_button 'Delete New Student'
       # page.driver.browser.switch_to.alert.accept
       # page.current_path.must_equal '/users'
       # page.text.wont_include 'New Student'
       # page.body.wont_include 'Delete Dave Jachimiak'
       # click_link 'Users'
       # click_link 'New user'
       # fill_in 'user_name', with: 'New Student'
       # fill_in 'user_email', with: 'new.student@neu.edu'
       # fill_in 'user_password', with: 'password'
       # fill_in 'user_password_confirmation', with: 'password'
       # click_button 'Create'
       # click_link 'Sign out'
     # end

     # it "allows admin users to destroy cohabitants" do
       # FactoryGirl.create(:cohabitant)
       # test_sign_in_admin
 
       # click_link 'Cohabitants'
       # click_button 'Delete Cool Factory'
       # page.driver.browser.switch_to.alert.accept
       # page.current_path.must_equal '/cohabitants'
       # page.text.wont_include 'Cool Factory'
     # end
  # end
end
