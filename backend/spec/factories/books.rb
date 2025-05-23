FactoryBot.define do
  factory :book do
    title { [ "The #{Faker::Lorem.word.capitalize} of #{Faker::Lorem.word.capitalize}",
    "#{Faker::Lorem.word.capitalize} #{Faker::Lorem.word.capitalize}",
    "#{Faker::Name.first_name}'s #{Faker::Lorem.word.capitalize}" ].sample }
    author { Faker::Book.author }
    isbn { "9788#{rand(10**9).to_s.rjust(9, '0')}" }
    quantity { [ 1, rand(2..20) ].sample }
    buy_price { (rand(899..4999) / 100.0).round(2) }  # $8.99 to $49.99
    borrow_price { (rand(199..999) / 100.0).round(2) } # $1.99 to $9.99
  end
end
