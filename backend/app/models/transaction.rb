class Transaction < ApplicationRecord
  include Constants

  enum :transaction_type, {
    buy: 0,
    borrow: 1,
    return: 2
  }

  belongs_to :user
  belongs_to :book

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :transaction_type, presence: true, inclusion: { in: transaction_types.keys }
  validates :transaction_date, presence: true
  validates :return_date, presence: true
end
