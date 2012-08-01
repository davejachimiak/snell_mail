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
  end

  factory :cohabitant do
    department    'Cool Factory'
    location      'Penthouse'
    contact_name  'Very Cool Guy'
    contact_email 'cool.guy@neu.edu'
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
    end
  end
end
