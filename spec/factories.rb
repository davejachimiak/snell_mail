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
end
