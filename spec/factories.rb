FactoryGirl.define do
  factory :user do
    name     'Dave Jachimiak'
    email    'd.jachimiak@neu.edu'
    password 'password'
    password_confirmation 'password'
    admin    true
  end

  factory :non_admin, class: User do
    name     'New Student'
    email    'new.student@neu.edu'
    password 'password'
    password_confirmation 'password'
    admin    false
  end
  
  factory :cohabitant do
    department    'Cool Factory'
    location      'Penthouse'
    contact_name  'Very Cool Guy'
    contact_email 'cool.guy@neu.edu'
  end
end
