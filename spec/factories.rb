FactoryGirl.define do
  factory :user do
    name 'Dave Jachimiak'
    email 'd.jachimiak@neu.edu'
    password 'password'
    password_confirmation 'password'
    admin true
    wants_update true

    factory :non_admin do
      name 'New Student'
      email 'new.student@neu.edu'
      admin false
      wants_update false
    end
    
    factory :admin_no_update do
      name 'Grumpy Diaper'
      email 'g.diaper@pamps.org'
      admin true
      wants_update false
    end
  end

  factory :cohabitant do
    department    'Cool Factory'
    location      'Penthouse'
    contact_name  'Very Cool Guy'
    contact_email 'cool.guy@neu.edu'

    factory :activated_cohabitant do
    end

    factory :deactivated_cohabitant do
      activated false
    end
  end

  factory :cohabitant_2, class: Cohabitant do
    department    'Jargon House'
    location      'Dungeon'
    contact_name  'Neck Beard'
    contact_email 'neck.beard@neu.edu'
  end

  factory :cohabitant_3, class: Cohabitant do
    department    'Face Surgery'
    location      '878SL'
    contact_name  'Moose Jaw'
    contact_email 'good.nose@neu.edu'
  end

  factory :cohabitant_4, class: Cohabitant do
    department    'Fun Section'
    location      'New Section'
    contact_name  'Super Cool Lady'
    contact_email 'cool.lady@neu.edu'
  end

  factory :notification do
    user

    factory :notification_by_non_admin do
      association :user, factory: :non_admin

      factory :notification_by_non_admin_two_cohabitants do
        after_build do |notification|
          notification.cohabitants << Factory(:cohabitant)
          notification.cohabitants << Factory(:cohabitant_4)
        end
      end
    end

    factory :notification_by_admin_no_update do
      association :user, factory: :admin_no_update
    end

    factory :notification_with_cohabitant do
      after_build do |notification|
        notification.cohabitants << Factory(:cohabitant)
      end
    end
  end
end
