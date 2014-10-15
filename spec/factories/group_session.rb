FactoryGirl.define do
  factory :group_session do
    title 'Free session'
    description 'My free session is fun'
    starts_at '3014-01-31 5:00pm'
    price ''
    host
  end

  factory :deleted_group_session, parent: :group_session do
    deleted_at Time.current
  end

  factory :priced_group_session, parent: :group_session do
    price 1
  end

  factory :free_group_session, parent: :group_session do
    price 0
  end

  factory :completed_group_session, parent: :group_session do
    ended_at Time.current
  end
end
