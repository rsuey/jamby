FactoryGirl.define do
  factory :user do
  end

  factory :signup do
    username 'userguy1'
    password 'secret83'
  end

  factory :signin do
    username 'signinguy'
    password 'secret83'
  end
end
