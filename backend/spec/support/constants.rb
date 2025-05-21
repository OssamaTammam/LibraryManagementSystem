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
end
