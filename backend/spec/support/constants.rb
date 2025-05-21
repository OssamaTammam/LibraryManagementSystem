# frozen_string_literal: true

module TestConstants
  PASSWORD_REGEX = /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}\z/
  EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/
  ISBN_REGEX = /\A\d{13}\z/

  DEFAULT_USER_PARAMS = {
    username: 'testuser',
    email: 'testuser@email.com',
    password: 'Password123!',
    password_confirmation: 'Password123!'
  }.freeze

  DEFAULT_BOOK_PARAMS = {
        title: 'Test Book',
        author: 'Test Author',
        isbn: '1234567890123',
        quantity: 5,
        buy_price: 29.99,
        borrow_price: 5.99
  }.freeze
end
