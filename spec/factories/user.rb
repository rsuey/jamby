FactoryGirl.define do
  factory :user do
    first_name 'Joe'
    last_name 'User'
  end

  factory :signup do
    first_name 'Joe'
    last_name 'User'
    email 'userguy1@email.com'
    password 'secret83'
  end

  factory :signin do
    first_name 'Joe'
    last_name 'User'
    email 'userguy1@email.com'
    password 'secret83'
  end
end
