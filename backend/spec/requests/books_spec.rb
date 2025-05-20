# spec/requests/api/v1/books_spec.rb
require 'rails_helper'

RSpec.describe "Api::V1::BooksController", type: :request do
  # Make TestConstants available if needed
  before do
    stub_const('Constants', TestConstants) unless defined?(Constants)

    # Stub Pundit authorization (if needed in request specs)
    allow_any_instance_of(Api::V1::BooksController).to receive(:authorize).and_return(true)

    # If you need to bypass authentication
    allow_any_instance_of(Api::ApiController).to receive(:authenticate_request!).and_return(true)
  end

  describe 'GET /api/v1/books' do
    let!(:books) { create_list(:book, 3) }

    it 'returns a list of books' do
      get '/api/v1/books'

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body).with_indifferent_access
      expect(json_response).to have_key(:books)
      expect(json_response[:books].length).to eq(3)
    end
  end

  describe 'GET /api/v1/books/:id' do
    let!(:book) { create(:book) }

    it 'returns the requested book' do
      get "/api/v1/books/#{book.id}"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body).with_indifferent_access
      expect(json_response).to have_key(:book)
      expect(json_response[:book][:id]).to eq(book.id)
    end

    it 'returns error when book not found' do
      get "/api/v1/books/999"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/v1/books' do
    let(:valid_params) do
      {
        title: 'Test Book',
        author: 'Test Author',
        isbn: '1234567890123', # 13 digits as per regex
        quantity: 5,
        buy_price: 29.99,
        borrow_price: 5.99
      }
    end

    it 'creates a new book with valid params' do
      expect {
        post '/api/v1/books', params: valid_params
      }.to change(Book, :count).by(1)

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body).with_indifferent_access
      expect(json_response).to have_key(:book)
      expect(json_response[:book][:title]).to eq('Test Book')
    end

    it 'returns error with invalid params' do
      invalid_params = valid_params.merge(isbn: 'invalid')

      expect {
        post '/api/v1/books', params: invalid_params
      }.not_to change(Book, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /api/v1/books/:id' do
    let!(:book) { create(:book, title: 'Old Title') }

    it 'updates an existing book' do
      put "/api/v1/books/#{book.id}", params: { title: 'New Title' }

      expect(response).to have_http_status(:ok)
      expect(book.reload.title).to eq('New Title')

      json_response = JSON.parse(response.body).with_indifferent_access
      expect(json_response).to have_key(:book)
      expect(json_response[:book][:title]).to eq('New Title')
    end

    it 'returns error when book not found' do
      put "/api/v1/books/999", params: { title: 'New Title' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/v1/books/:id' do
    let!(:book) { create(:book) }

    it 'deletes the book' do
      expect {
        delete "/api/v1/books/#{book.id}"
      }.to change(Book, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it 'returns error when book not found' do
      delete "/api/v1/books/999"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/v1/books/borrow' do
    let!(:book) { create(:book, quantity: 2, borrow_price: 5.0) }
    let!(:user) { create(:user) }

    it 'creates a borrow transaction' do
      expect {
        post "/api/v1/books/borrow", params: { book_id: book.id, user_id: user.id, days: 7 }
      }.to change(Transaction, :count).by(1)

      expect(response).to have_http_status(:ok)
      expect(book.reload.quantity).to eq(1)

      json_response = JSON.parse(response.body).with_indifferent_access
      expect(json_response).to have_key(:transaction)
      expect(json_response[:transaction][:price].to_f).to eq(35.0) # 5.0 * 7 days
    end

    it 'returns error when book not available' do
      book.update(quantity: 0)

      post "/api/v1/books/borrow", params: { book_id: book.id, user_id: user.id, days: 7 }

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body).with_indifferent_access
      expect(json_response[:message]).to eq('Book not available')
    end
  end

  describe 'POST /api/v1/books/buy' do
    let!(:book) { create(:book, quantity: 2, buy_price: 15.0) }
    let!(:user) { create(:user) }

    it 'creates a buy transaction' do
      expect {
        post "/api/v1/books/buy", params: { book_id: book.id, user_id: user.id }
      }.to change(Transaction, :count).by(1)

      expect(response).to have_http_status(:ok)
      expect(book.reload.quantity).to eq(1)

      json_response = JSON.parse(response.body).with_indifferent_access
      expect(json_response).to have_key(:transaction)
      expect(json_response[:transaction][:price].to_f).to eq(15.0)
    end

    it 'returns error when book not found' do
      post "/api/v1/books/buy", params: { user_id: user.id }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/v1/books/return' do
    let!(:book) { create(:book, quantity: 1) }
    let!(:user) { create(:user) }
    let!(:transaction) do
      create(:transaction,
             user: user,
             book: book,
             transaction_type: :borrow,
             price: 35.0, # Add price to fix validation
             transaction_date: 5.days.ago,
             return_date: 2.days.from_now)
    end

    it 'updates the transaction and book when returning' do
      expect {
        post "/api/v1/books/return", params: { book_id: book.id, transaction_id: transaction.id }
      }.to change { book.reload.quantity }.by(1)

      expect(response).to have_http_status(:ok)
      expect(transaction.reload.return_date.to_date).to eq(Time.current.to_date)

      json_response = JSON.parse(response.body).with_indifferent_access
      expect(json_response).to have_key(:transaction)
    end

    it 'returns error when book already returned' do
      transaction.update(return_date: 1.day.ago)

      post "/api/v1/books/return", params: { book_id: book.id, transaction_id: transaction.id }

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body).with_indifferent_access
      expect(json_response[:message]).to eq('Book already returned')
    end
  end

  # Helper method to parse JSON response
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end
end
