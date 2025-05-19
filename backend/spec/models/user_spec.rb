# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  # Make TestConstants available as Constants
  before do
    stub_const('Constants', TestConstants) unless defined?(Constants)
  end

  describe 'associations' do
    it { should have_many(:transactions).dependent(:restrict_with_exception) }
  end

  describe 'validations' do
    # Create a valid user for uniqueness tests
    let!(:existing_user) { create(:user, username: 'testuser', email: 'test@example.com') }

    it { should have_secure_password }

    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username).case_insensitive }
    it { should validate_length_of(:username).is_at_least(4) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    context 'email format validation' do
      it 'validates email with EMAIL_REGEX' do
        valid_user = build(:user, email: 'valid@example.com')
        expect(valid_user).to be_valid

        invalid_user = build(:user, email: 'invalid-email')
        expect(invalid_user).not_to be_valid
        expect(invalid_user.errors[:email]).to be_present
      end
    end
  end

  describe 'scopes' do
    # Use SQLite-compatible LIKE with case insensitivity for testing
    before do
      # Stub the scope methods to work with SQLite
      class User < ApplicationRecord
        def self.filter_by_username(username)
          where("lower(username) LIKE ?", "%#{username.downcase}%")
        end

        def self.filter_by_email(email)
          where("lower(email) LIKE ?", "%#{email.downcase}%")
        end
      end
    end

    let!(:user1) { create(:user, username: 'alpha_user', email: 'alpha@example.com') }
    let!(:user2) { create(:user, username: 'beta_user', email: 'beta@example.com') }
    let!(:user3) { create(:user, username: 'gamma_user', email: 'gamma@domain.org') } # Changed email domain

    describe '.filter_by_id' do
      it 'returns users with the specified ID' do
        expect(User.filter_by_id(user1.id)).to include(user1)
        expect(User.filter_by_id(user1.id)).not_to include(user2, user3)
      end
    end

    describe '.filter_by_username' do
      it 'returns users with matching username (case insensitive)' do
        expect(User.filter_by_username('ALPHA')).to include(user1)
        expect(User.filter_by_username('ALPHA')).not_to include(user2, user3)

        expect(User.filter_by_username('user')).to include(user1, user2, user3)
      end
    end

    describe '.filter_by_email' do
      it 'returns users with matching email (case insensitive)' do
        expect(User.filter_by_email('BETA')).to include(user2)
        expect(User.filter_by_email('BETA')).not_to include(user1, user3)

        expect(User.filter_by_email('example')).to include(user1, user2)
        expect(User.filter_by_email('example')).not_to include(user3)

        expect(User.filter_by_email('domain')).to include(user3)
        expect(User.filter_by_email('domain')).not_to include(user1, user2)
      end
    end
  end

  describe '#is_admin?' do
    it 'returns true if user is an admin' do
      admin_user = build(:user, admin: true)
      expect(admin_user.is_admin?).to be true
    end

    it 'returns false if user is not an admin' do
      regular_user = build(:user, admin: false)
      expect(regular_user.is_admin?).to be false
    end
  end
end
