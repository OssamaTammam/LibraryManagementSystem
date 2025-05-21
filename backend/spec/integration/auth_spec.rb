# spec/integration/auth_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/auth', swagger_doc: 'v1/swagger.yaml', type: :request do
  path '/api/v1/auth/signup' do
    post 'Registers a new user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          email: { type: :string, format: :email },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: %w[username email password password_confirmation]
      }

      response '201', 'user created' do
        let(:user) do
          {
            username: 'testuser',
            email: 'user@example.com',
            password: 'Password123!',
            password_confirmation: 'Password123!'
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['user']['email']).to eq('user@example.com')
        end
      end

      response '422', 'validation errors' do
        let(:user) do
          {
            username: 'a',
            email: 'invalid-email',
            password: 'Password123!',
            password_confirmation: 'mismatch'
          }
        end

        run_test!
      end
    end
  end

  path '/api/v1/auth/login' do
    post 'Logs in a user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, format: :email },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response '200', 'login successful' do
        let!(:user_record) do
          User.create!(
            username: 'testuser',
            email: 'user@example.com',
            password: 'Password123!',
            password_confirmation: 'Password123!'
          )
        end

        let(:credentials) do
          {
            email: 'user@example.com',
            password: 'Password123!'
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Sign in successful')
        end
      end

      response '401', 'unauthorized' do
        let(:credentials) do
          {
            email: 'wrong@example.com',
            password: 'badpassword'
          }
        end

        run_test!
      end
    end
  end
end
