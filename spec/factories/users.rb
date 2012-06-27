FactoryGirl.define do 
  factory :user do
    role 'member'
    sequence(:username) {|n|"user_#{n}" }
    password 'password'
    password_confirmation 'password'
  end
end