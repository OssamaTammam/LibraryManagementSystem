class Book < ApplicationRecord
  include Constants

  has_many :transactions, dependent: :restrict_with_exception

  validates :title, presence: true
  validates :author, presence: true
  validates :isbn, presence: true, format: ISBN_REGEX
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :buy_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :borrow_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :filter_by_id, ->(id) { where(id: id) }
  scope :filter_by_isbn, ->(isbn) { where(isbn: isbn) }
  scope :filter_by_quantity, ->(quantity) { where(quantity: quantity) }
  scope :filter_by_title, ->(title) { where("title ILIKE ?", "%#{title}%") }
  scope :filter_by_author, ->(author) { where("author ILIKE ?", "%#{author}%") }
end
