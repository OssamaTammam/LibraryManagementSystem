FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "Sample Book #{n}" }
    sequence(:author) { |n| "Author #{n}" }
    sequence(:isbn) { |n| (9780000000000 + n).to_s } # Generates valid-looking ISBN-13s
    quantity { rand(1..10) }
    buy_price { rand(10.0..100.0).round(2) }
    borrow_price { rand(1.0..20.0).round(2) }
  end
end
