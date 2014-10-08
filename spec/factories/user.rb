FactoryGirl.define do
  factory :user do
    first_name 'Joe'
    last_name 'User'
    sequence(:email) { |n| "userguy#{n}@email.com" }
  end

  factory :account do
    first_name 'Joe'
    last_name 'Account'
    sequence(:email) { |n| "accountguy#{n}@email.com" }
    password 'secret83'
  end

  factory :signup, aliases: [:host] do
    first_name 'Joe'
    last_name 'Signup'
    sequence(:email) { |n| "signupguy#{n}@email.com" }
    password 'secret83'
  end

  factory :signin do
    first_name 'Joe'
    last_name 'Signin'
    sequence(:email) { |n| "signinguy#{n}@email.com" }
    password 'secret83'
  end
end
