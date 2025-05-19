class Transaction < ApplicationRecord
  include Constants

  enum transaction_type: {
    buy: 0,
    borrow: 1,
    return: 2
  }

  belongs_to :user
  belongs_to :book

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :transaction_type, presence: true, inclusion: { in: TRANSACTION_TYPES }
  validates :transaction_date, presence: true
  validates :return_date, presence: true, date: { after_or_equal_to: :transaction_date }
  validate :return_date_cannot_be_in_the_past
  validate :transaction_date_cannot_be_in_the_future

  private

  def return_date_cannot_be_in_the_past
    return if return_date.blank?

    if return_date < Date.today
      errors.add(:return_date, "can't be in the past")
    end
  end

  def transaction_date_cannot_be_in_the_future
    return if transaction_date.blank?

    if transaction_date > Date.today
      errors.add(:transaction_date, "can't be in the future")
    end
  end
end
