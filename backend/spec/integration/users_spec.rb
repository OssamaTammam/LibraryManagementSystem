require 'swagger_helper'

RSpec.describe 'API::V1::Users', swagger_doc: 'v1/swagger.yaml', type: :request do
  let(:password) { TestConstants::DEFAULT_USER_PARAMS[:password] }

  path '/api/v1/users/me' do
    get 'Get current user' do
      tags 'Users'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'current user found' do
        let(:user) { create(:user) }

        before do
          post '/api/v1/auth/login', params: {
            email: user.email,
            password: password
          }
        end

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json['user']['id']).to eq(user.id)
        end
      end

      response '401', 'unauthorized' do
        before { cookies.delete(:jwt) }
        run_test!
      end
    end

    put 'Update current user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]
      parameter name: :user_params, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string }
        },
        required: [ 'username' ]
      }

      response '200', 'user updated' do
        let(:user) { create(:user) }

        let(:user_params) { { username: 'updatedusername' } }

        before do
          post '/api/v1/auth/login', params: {
            email: user.email,
            password: password
          }
        end

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json['user']['username']).to eq('updatedusername')
        end
      end
    end

    delete 'Delete current user' do
      tags 'Users'
      security [ cookie_auth: [] ]

      response '204', 'user deleted' do
        let(:user) { create(:user) }

        before do
          post '/api/v1/auth/login', params: {
            email: user.email,
            password: password
          }
        end

        run_test!
      end
    end
  end

  path '/api/v1/users' do
    get 'List all users (admin only)' do
      tags 'Users'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'list of users' do
        let!(:users) { create_list(:user, 3) }
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

  path '/api/v1/users/{id}' do
    parameter name: :id, in: :path, type: :string

    get 'Get specific user (admin only)' do
      tags 'Users'
      produces 'application/json'
      security [ cookie_auth: [] ]

      response '200', 'user found' do
        let(:user) { create(:user) }
        let(:id) { user.id }
        let(:admin) { create(:user, admin: true) }

        before do
          post '/api/v1/auth/login', params: {
            email: admin.email,
            password: password
          }
        end

        run_test!
      end

      response '404', 'user not found' do
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

    put 'Update specific user (admin only)' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      security [ cookie_auth: [] ]
      parameter name: :user_params, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          email: { type: :string },
          admin: { type: :boolean }
        }
      }

      response '200', 'user updated' do
        let(:user) { create(:user) }
        let(:id) { user.id }
        let(:user_params) do
          { username: 'updatedusername', email: 'updated@example.com', admin: true }
        end
        let(:admin) { create(:user, admin: true) }

        before do
          post '/api/v1/auth/login', params: {
            email: admin.email,
            password: password
          }
        end

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json['user']['username']).to eq('updatedusername')
        end
      end

      response '404', 'user not found' do
        let(:id) { '999' }
        let(:user_params) { { username: 'test' } }
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

    delete 'Delete specific user (admin only)' do
      tags 'Users'
      security [ cookie_auth: [] ]

      response '204', 'user deleted' do
        let!(:user) { create(:user) }
        let(:id) { user.id }
        let(:admin) { create(:user, admin: true) }

        before do
          post '/api/v1/auth/login', params: {
            email: admin.email,
            password: password
          }
        end

        run_test!
      end

      response '404', 'user not found' do
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
