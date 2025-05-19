FactoryBot.define do
  factory :transaction do
    association :user
    association :book

    transaction_type { "borrow" } # or "buy", "return"
    transaction_date { Date.today }
    return_date { transaction_date + 7.days }
    price { rand(5.0..50.0).round(2) }
  end
end
