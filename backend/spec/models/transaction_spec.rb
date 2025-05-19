# spec/models/transaction_spec.rb
require 'rails_helper'

RSpec.describe Transaction, type: :model do
  # Make TestConstants available as Constants if needed
  before do
    stub_const('Constants', TestConstants) unless defined?(Constants)
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:book) }
  end

  describe 'validations' do
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }

    it { should validate_presence_of(:transaction_type) }
    it { should validate_presence_of(:transaction_date) }
    it { should validate_presence_of(:return_date) }

    it { should define_enum_for(:transaction_type).with_values(buy: 0, borrow: 1, return: 2) }
  end

  describe 'enum transaction_type' do
    let(:buy_transaction) { build(:transaction, transaction_type: :buy) }
    let(:borrow_transaction) { build(:transaction, transaction_type: :borrow) }
    let(:return_transaction) { build(:transaction, transaction_type: :return) }

    it 'can be set to buy' do
      expect(buy_transaction.transaction_type).to eq('buy')
      expect(buy_transaction.buy?).to be true
      expect(buy_transaction.borrow?).to be false
      expect(buy_transaction.return?).to be false
    end

    it 'can be set to borrow' do
      expect(borrow_transaction.transaction_type).to eq('borrow')
      expect(borrow_transaction.buy?).to be false
      expect(borrow_transaction.borrow?).to be true
      expect(borrow_transaction.return?).to be false
    end

    it 'can be set to return' do
      expect(return_transaction.transaction_type).to eq('return')
      expect(return_transaction.buy?).to be false
      expect(return_transaction.borrow?).to be false
      expect(return_transaction.return?).to be true
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:transaction)).to be_valid
    end
  end
end
