FactoryGirl.define do
  factory :payment do
  end

  factory :deleted_payment, parent: :payment do
    deleted_at Time.current
  end
end
