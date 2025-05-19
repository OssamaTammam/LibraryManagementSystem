FactoryBot.define do
  factory :transaction do
    association :user
    association :book

    transaction_type { "borrow" }
    transaction_date { Date.today - rand(0..7).days }
    return_date { |t| t.transaction_type == "borrow" ? t.transaction_date + rand(7..30).days : nil }

    price { |t|
      case t.transaction_type
      when "borrow"
        t.book.borrow_price || rand(2.99..9.99).round(2)
      when "buy"
        t.book.buy_price || rand(9.99..49.99).round(2)
      when "return"
        0 # Returns don't typically have a price
      end
    }

    trait :buy do
      transaction_type { "buy" }
      return_date { nil }
    end

    trait :borrow do
      transaction_type { "borrow" }
    end

    trait :return do
      transaction_type { "return" }

      # For returns, we need a previous borrow transaction
      transient do
        previous_borrow { nil }
      end

      # Set the price to 0 for returns
      price { 0 }

      # If a specific previous borrow is provided, use its details
      before(:create) do |transaction, evaluator|
        if evaluator.previous_borrow
          transaction.book = evaluator.previous_borrow.book
          transaction.user = evaluator.previous_borrow.user
          transaction.transaction_date = Date.today
          # If the book is being returned early, there might be a fee
          transaction.price = Date.today > evaluator.previous_borrow.return_date ? rand(1..10).round(2) : 0
        end
      end
    end
  end
end
