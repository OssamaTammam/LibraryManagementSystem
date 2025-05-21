require 'swagger_helper'

RSpec.describe 'API::V1::Transactions', swagger_doc: 'v1/swagger.yaml', type: :request do
  let(:password) { TestConstants::DEFAULT_USER_PARAMS[:password] }

  path '/api/v1/transactions' do
    get 'List all transactions (admin only)' do
      tags 'Transactions'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'transactions listed' do
        let!(:transactions) { create_list(:transaction, 3) }
        let(:admin) { create(:user, admin: true) }

        before do
          post '/api/v1/auth/login', params: {
            email: admin.email,
            password: password
          }
        end

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json['transactions'].length).to eq(3)
        end
      end
    end
  end

  path '/api/v1/transactions/{id}' do
    parameter name: :id, in: :path, type: :string

    get 'Get a specific transaction (admin only)' do
      tags 'Transactions'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'transaction found' do
        let(:transaction) { create(:transaction) }
        let(:id) { transaction.id }
        let(:admin) { create(:user, admin: true) }

        before do
          post '/api/v1/auth/login', params: {
            email: admin.email,
            password: password
          }
        end

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json['transaction']['id']).to eq(transaction.id)
        end
      end

      response '404', 'transaction not found' do
        let(:id) { '999' }
        let(:admin) { create(:user, admin: true) }

        before do
          post '/api/v1/auth/login', params: {
            email: admin.email,
            password: password
          }
        end

        run_test!
      end
    end
  end
end
