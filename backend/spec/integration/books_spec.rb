# spec/requests/api/v1/books_swagger_spec.rb
require 'swagger_helper'

RSpec.describe 'Books API', type: :request do
  # Define shared parameters
  path '/api/v1/books' do
    get 'Lists all books' do
      tags 'Books'
      produces 'application/json'

      response '200', 'books found' do
        schema type: :object,
               properties: {
                 success: { type: :boolean },
                 books: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       title: { type: :string },
                       author: { type: :string },
                       isbn: { type: :string },
                       quantity: { type: :integer },
                       buy_price: { type: :string },  # Changed from number to string
                       borrow_price: { type: :string },  # Changed from number to string
                       created_at: { type: :string, format: 'date-time' },
                       updated_at: { type: :string, format: 'date-time' }
                     },
                     required: [ 'id', 'title', 'author', 'isbn', 'quantity' ]
                   }
                 }
               }

        before do
          create_list(:book, 3)
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('books')
        end
      end
    end

    post 'Creates a book' do
      tags 'Books'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]

      parameter name: :book, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          author: { type: :string },
          isbn: { type: :string },
          quantity: { type: :integer },
          buy_price: { type: :number, format: :float },
          borrow_price: { type: :number, format: :float }
        },
        required: [ 'title', 'author', 'isbn', 'quantity' ]
      }

      response '201', 'book created' do
        let(:admin) { create(:user, admin: true) }
        let(:book) { TestConstants::DEFAULT_BOOK_PARAMS }

        before do
          post '/api/v1/auth/login', params: {
            email: admin.email,
            password: TestConstants::DEFAULT_USER_PARAMS[:password]
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('book')
          expect(data['book']['title']).to eq('Test Book')
        end
      end

      response '422', 'invalid request' do
        let(:admin) { create(:user, admin: true) }
        let(:book) { { title: 'Invalid Book', isbn: 'invalid' } }

        before do
          post '/api/v1/auth/login', params: {
            email: admin.email,
            password: TestConstants::DEFAULT_USER_PARAMS[:password]
          }
        end

        run_test!
      end

      response '401', 'unauthorized access' do
        let(:book) { TestConstants::DEFAULT_BOOK_PARAMS }
        # No authentication provided

        run_test!
      end
    end
  end

  path '/api/v1/books/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves a book' do
      tags 'Books'
      produces 'application/json'

      response '200', 'book found' do
        schema type: :object,
               properties: {
                 success: { type: :boolean },
                 book: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     title: { type: :string },
                     author: { type: :string },
                     isbn: { type: :string },
                     quantity: { type: :integer },
                     buy_price: { type: :string },  # Changed from number to string
                     borrow_price: { type: :string },  # Changed from number to string
                     created_at: { type: :string, format: 'date-time' },
                     updated_at: { type: :string, format: 'date-time' }
                   }
                 }
               }

        let(:id) { create(:book).id }
        run_test!
      end

      response '404', 'book not found' do
        let(:id) { 999 }
        run_test!
      end
    end

    put 'Updates a book' do
      tags 'Books'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]

      parameter name: :book, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          author: { type: :string },
          isbn: { type: :string },
          quantity: { type: :integer },
          buy_price: { type: :number, format: :float },
          borrow_price: { type: :number, format: :float }
        }
      }

      response '200', 'book updated' do
        let(:admin) { create(:user, admin: true) }
        let(:id) { create(:book).id }
        let(:book) { { title: 'Updated Title' } }

        before do
          post '/api/v1/auth/login', params: {
            email: admin.email,
            password: TestConstants::DEFAULT_USER_PARAMS[:password]
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['book']['title']).to eq('Updated Title')
        end
      end

      response '404', 'book not found' do
        let(:admin) { create(:user, admin: true) }
        let(:id) { 999 }
        let(:book) { { title: 'Updated Title' } }

        before do
          post '/api/v1/auth/login', params: {
            email: admin.email,
            password: TestConstants::DEFAULT_USER_PARAMS[:password]
          }
        end

        run_test!
      end

      response '401', 'unauthorized access' do
        let(:id) { create(:book).id }
        let(:book) { { title: 'Updated Title' } }
        # No authentication provided

        run_test!
      end
    end

    delete 'Deletes a book' do
      tags 'Books'
      security [ cookie_auth: [] ]

      response '204', 'book deleted' do
        let(:admin) { create(:user, admin: true) }
        let(:id) { create(:book).id }

        before do
          post '/api/v1/auth/login', params: {
            email: admin.email,
            password: TestConstants::DEFAULT_USER_PARAMS[:password]
          }
        end

        run_test!
      end

      response '404', 'book not found' do
        let(:admin) { create(:user, admin: true) }
        let(:id) { 999 }

        before do
          post '/api/v1/auth/login', params: {
            email: admin.email,
            password: TestConstants::DEFAULT_USER_PARAMS[:password]
          }
        end

        run_test!
      end

      response '401', 'unauthorized access' do
        let(:id) { create(:book).id }
        # No authentication provided

        run_test!
      end
    end
  end

  path '/api/v1/books/borrow' do
    post 'Borrows a book' do
      tags 'Book Transactions'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          book_id: { type: :integer },
          days: { type: :integer }
        },
        required: [ 'book_id', 'user_id', 'days' ]
      }

      response '200', 'book borrowed successfully' do
        schema type: :object,
               properties: {
                 success: { type: :boolean },
                 transaction: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     user_id: { type: :integer },
                     book_id: { type: :integer },
                     transaction_type: { type: :string },
                     transaction_date: { type: :string, format: 'date-time' },
                     return_date: { type: :string, format: 'date-time' },
                     price: { type: :string },  # Changed from number to string
                     user: { type: :object },
                     book: { type: :object }
                   }
                 }
               }

        let(:admin) { create(:user, admin: true) }
        let(:book) { create(:book, quantity: 2, borrow_price: 5.0) }
        let(:user) { create(:user) }
        let(:params) { { book_id: book.id, user_id: user.id, days: 7 } }

        before do
          post '/api/v1/auth/login', params: {
            email: admin.email,
            password: TestConstants::DEFAULT_USER_PARAMS[:password]
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('transaction')
          expect(data['transaction']['price'].to_f).to eq(35.0)
        end
      end

      response '422', 'book not available' do
        let(:admin) { create(:user, admin: true) }
        let(:book) { create(:book, quantity: 0) }
        let(:user) { create(:user) }
        let(:params) { { book_id: book.id, user_id: user.id, days: 7 } }

        before do
          post '/api/v1/auth/login', params: {
            email: admin.email,
            password: TestConstants::DEFAULT_USER_PARAMS[:password]
          }
        end

        run_test!
      end

      response '401', 'unauthorized access' do
        let(:book) { create(:book) }
        let(:user) { create(:user) }
        let(:params) { { book_id: book.id, user_id: user.id, days: 7 } }
        # No authentication provided

        run_test!
      end
    end
  end

  path '/api/v1/books/buy' do
    post 'Purchases a book' do
      tags 'Book Transactions'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          book_id: { type: :integer }
        },
        required: [ 'book_id', 'user_id' ]
      }

      response '200', 'book purchased successfully' do
        schema type: :object,
               properties: {
                 success: { type: :boolean },
                 transaction: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     user_id: { type: :integer },
                     book_id: { type: :integer },
                     transaction_type: { type: :string },
                     transaction_date: { type: :string, format: 'date-time' },
                     return_date: { type: [ :string, :null ], format: 'date-time', nullable: true },
                     price: { type: :string },  # Changed from number to string
                     user: { type: :object },
                     book: { type: :object }
                   }
                 }
               }

        let(:admin) { create(:user, admin: true) }
        let(:book) { create(:book, quantity: 2, buy_price: 15.0) }
        let(:user) { create(:user) }
        let(:params) { { book_id: book.id, user_id: user.id } }

        before do
          post '/api/v1/auth/login', params: {
            email: admin.email,
            password: TestConstants::DEFAULT_USER_PARAMS[:password]
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('transaction')
          expect(data['transaction']['price'].to_f).to eq(15.0)
        end
      end

      response '404', 'book not found' do
        let(:admin) { create(:user, admin: true) }
        let(:user) { create(:user) }
        let(:params) { { user_id: user.id } }

        before do
          post '/api/v1/auth/login', params: {
            email: admin.email,
            password: TestConstants::DEFAULT_USER_PARAMS[:password]
          }
        end

        run_test!
      end

      response '401', 'unauthorized access' do
        let(:book) { create(:book) }
        let(:user) { create(:user) }
        let(:params) { { book_id: book.id, user_id: user.id } }
        # No authentication provided

        run_test!
      end
    end
  end

  path '/api/v1/books/return' do
    post 'Returns a borrowed book' do
      tags 'Book Transactions'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          book_id: { type: :integer },
          transaction_id: { type: :integer }
        },
        required: [ 'book_id', 'transaction_id' ]
      }

      response '200', 'book returned successfully' do
        schema type: :object,
               properties: {
                 success: { type: :boolean },
                 transaction: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     user_id: { type: :integer },
                     book_id: { type: :integer },
                     transaction_type: { type: :string },
                     transaction_date: { type: :string, format: 'date-time' },
                     return_date: { type: :string, format: 'date-time' },
                     price: { type: :string },  # Changed from number to string
                     user: { type: :object },
                     book: { type: :object }
                   }
                 }
               }

        let(:admin) { create(:user, admin: true) }
        let(:book) { create(:book, quantity: 1) }
        let(:user) { create(:user) }
        let(:transaction) do
          create(:transaction,
                 user: user,
                 book: book,
                 transaction_type: :borrow,
                 price: 35.0,
                 transaction_date: 5.days.ago,
                 return_date: 2.days.from_now)
        end
        let(:params) { { book_id: book.id, transaction_id: transaction.id } }

        before do
          post '/api/v1/auth/login', params: {
            email: admin.email,
            password: TestConstants::DEFAULT_USER_PARAMS[:password]
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('transaction')
          expect(Date.parse(data['transaction']['return_date'])).to eq(Date.today)
        end
      end

      response '422', 'book already returned' do
        let(:admin) { create(:user, admin: true) }
        let(:book) { create(:book) }
        let(:user) { create(:user) }
        let(:transaction) do
          create(:transaction,
                 user: user,
                 book: book,
                 transaction_type: :borrow,
                 price: 35.0,
                 transaction_date: 5.days.ago,
                 return_date: 1.day.ago)
        end
        let(:params) { { book_id: book.id, transaction_id: transaction.id } }

        before do
          post '/api/v1/auth/login', params: {
            email: admin.email,
            password: TestConstants::DEFAULT_USER_PARAMS[:password]
          }
        end

        run_test!
      end

      response '401', 'unauthorized access' do
        let(:book) { create(:book) }
        let(:transaction) { create(:transaction, book: book) }
        let(:params) { { book_id: book.id, transaction_id: transaction.id } }
        # No authentication provided

        run_test!
      end
    end
  end
end
