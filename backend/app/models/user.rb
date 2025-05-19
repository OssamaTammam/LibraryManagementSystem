class User < ApplicationRecord
  include Constants

  has_secure_password # password_digest column
  has_many :transactions, dependent: :restrict_with_exception

  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 4 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: EMAIL_REGEX

  scope :filter_by_id, ->(id) { where(id: id) }
  scope :filter_by_username, ->(username) { where("username ILIKE ?", "%#{username}%") }
  scope :filter_by_email, ->(email) { where("email ILIKE ?", "%#{email}%") }

  def is_admin?
    self.admin
  end
end
