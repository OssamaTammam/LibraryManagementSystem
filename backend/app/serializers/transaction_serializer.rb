class TransactionSerializer < ApplicationSerializer
  attributes :id, :price, :transaction_type, :transaction_date, :return_date

  attribute :user do
    UserSerializer.render(User.find(object.user_id))
  end

  attribute :book do
    BookSerializer.render(Book.find(object.book_id))
  end

  attribute :transaction_type do
    case object.transaction_type
    when 0
      "borrow"
    when 1
      "buy"
    when 2
      "return"
    else
      "unknown"
    end
  end
end
