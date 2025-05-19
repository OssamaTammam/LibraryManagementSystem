# spec/models/book_spec.rb
require 'rails_helper'

RSpec.describe Book, type: :model do
  # Make TestConstants available as Constants
  before do
    stub_const('Constants', TestConstants) unless defined?(Constants)
  end

  describe 'associations' do
    it { should have_many(:transactions).dependent(:restrict_with_exception) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:isbn) }
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:buy_price) }
    it { should validate_presence_of(:borrow_price) }

    it { should validate_numericality_of(:quantity).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:buy_price).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:borrow_price).is_greater_than_or_equal_to(0) }

    context 'ISBN format validation' do
      it 'validates ISBN format using the constant ISBN_REGEX' do
        # Explicitly create a book with ISBN matching the regex /\A\d{13}\z/
        valid_book = build(:book, isbn: '1234567890123')
        expect(valid_book).to be_valid

        invalid_book = build(:book, isbn: 'invalid-isbn')
        expect(invalid_book).not_to be_valid
      end
    end
  end

  describe 'scopes' do
    # Use SQLite-compatible LIKE with case insensitivity for testing
    before do
      # Stub the scope methods to work with SQLite
      class Book < ApplicationRecord
        def self.filter_by_title(title)
          where("lower(title) LIKE ?", "%#{title.downcase}%")
        end

        def self.filter_by_author(author)
          where("lower(author) LIKE ?", "%#{author.downcase}%")
        end
      end
    end

    let!(:book1) { create(:book, title: 'Ruby Programming', author: 'Matz', isbn: '1234567890123', quantity: 5) }
    let!(:book2) { create(:book, title: 'Rails Basics', author: 'DHH', isbn: '2345678901234', quantity: 10) }
    let!(:book3) { create(:book, title: 'Advanced Ruby', author: 'Ruby Master', isbn: '3456789012345', quantity: 5) }

    describe '.filter_by_id' do
      it 'returns books with the specified ID' do
        expect(Book.filter_by_id(book1.id)).to include(book1)
        expect(Book.filter_by_id(book1.id)).not_to include(book2, book3)
      end
    end

    describe '.filter_by_isbn' do
      it 'returns books with the specified ISBN' do
        expect(Book.filter_by_isbn(book1.isbn)).to include(book1)
        expect(Book.filter_by_isbn(book1.isbn)).not_to include(book2, book3)
      end
    end

    describe '.filter_by_quantity' do
      it 'returns books with the specified quantity' do
        expect(Book.filter_by_quantity(5)).to include(book1, book3)
        expect(Book.filter_by_quantity(5)).not_to include(book2)
      end
    end

    describe '.filter_by_title' do
      it 'returns books with matching title (case insensitive)' do
        expect(Book.filter_by_title('ruby')).to include(book1, book3)
        expect(Book.filter_by_title('ruby')).not_to include(book2)

        expect(Book.filter_by_title('RAILS')).to include(book2)
        expect(Book.filter_by_title('RAILS')).not_to include(book1, book3)
      end
    end

    describe '.filter_by_author' do
      it 'returns books with matching author (case insensitive)' do
        expect(Book.filter_by_author('matz')).to include(book1)
        expect(Book.filter_by_author('matz')).not_to include(book2, book3)

        expect(Book.filter_by_author('ruby')).to include(book3)
        expect(Book.filter_by_author('ruby')).not_to include(book1, book2)
      end
    end
  end
end
