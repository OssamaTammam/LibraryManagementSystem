# spec/requests/auth_spec.rb
require 'rails_helper'

RSpec.describe "Api::V1::AuthController", type: :request do
  describe 'POST /api/v1/auth/signup' do
    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          post '/api/v1/auth/signup', params: TestConstants::DEFAULT_USER_PARAMS
        }.to change(User, :count).by(1)
      end

      it 'returns a successful response with the created user' do
        post '/api/v1/auth/signup', params: TestConstants::DEFAULT_USER_PARAMS

        expect(response).to have_http_status(:created)
        expect(json_response).to have_key(:user)
        expect(json_response[:user]).to include(
          username: TestConstants::DEFAULT_USER_PARAMS[:username],
          email: TestConstants::DEFAULT_USER_PARAMS[:email]
        )
      end
    end

    context 'with invalid parameters' do
      it 'returns an error when passwords do not match' do
      invalid_params = TestConstants::DEFAULT_USER_PARAMS.merge(password_confirmation: 'different')

        expect {
          post '/api/v1/auth/signup', params: invalid_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error when email is invalid' do
        invalid_params = TestConstants::DEFAULT_USER_PARAMS.merge(email: 'invalid-email')

        expect {
          post '/api/v1/auth/signup', params: invalid_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error when username is too short' do
        invalid_params = TestConstants::DEFAULT_USER_PARAMS.merge(username: 'a')

        expect {
          post '/api/v1/auth/signup', params: invalid_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST /api/v1/auth/login' do
    let!(:user) { create(:user, email: TestConstants::DEFAULT_USER_PARAMS[:email], password: TestConstants::DEFAULT_USER_PARAMS[:password]) }

    context 'with valid credentials' do
      it 'returns a successful response with sign in message' do
        # Mock JWT encoding
        allow(JsonWebToken).to receive(:encode).and_return('fake-jwt-token')

        post '/api/v1/auth/login', params: TestConstants::DEFAULT_USER_PARAMS

        expect(response).to have_http_status(:ok)
        expect(json_response[:message]).to eq('Sign in successful')
      end

      it 'sets the JWT token in a cookie' do
        jwt_token = 'fake-jwt-token'
        allow(JsonWebToken).to receive(:encode).and_return(jwt_token)

        post '/api/v1/auth/login', params: TestConstants::DEFAULT_USER_PARAMS

        jar = ActionDispatch::Cookies::CookieJar.build(request, cookies.to_hash)
        expect(jar.encrypted['jwt']).to eq(jwt_token)
      end
    end

    context 'with invalid credentials' do
      it 'returns an error when email does not exist' do
        post '/api/v1/auth/login', params: { email: 'nonexistent@example.com', password: 'Password123!' }

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error when password is incorrect' do
        post '/api/v1/auth/login', params: { email: 'test@example.com', password: 'WrongPassword123!' }

        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:message]).to eq('Invalid email or password')
      end
    end
  end

  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end
end
