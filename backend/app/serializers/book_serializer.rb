class BookSerializer < ApplicationSerializer
  attributes :id, :title, :author, :isbn, :quantity, :buy_price, :borrow_price, :created_at, :updated_at

  def published_date
    object.published_date.strftime("%B %d, %Y")
  end
end
