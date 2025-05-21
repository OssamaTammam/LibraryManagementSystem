require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  before do
    admin = create(:user, admin: true)
    post '/api/v1/auth/login', params: {
      email: admin.email,
      password: TestConstants::DEFAULT_USER_PARAMS[:password]
  }
  end

  describe "GET /api/v1/transactions" do
    let!(:transactions) { create_list(:transaction, 3) }

    it "returns a list of transactions" do
      get "/api/v1/transactions"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body).with_indifferent_access
      expect(json_response).to have_key(:transactions)
      expect(json_response[:transactions].length).to eq(3)
    end
  end

  describe "GET /api/v1/transactions/:id" do
    let!(:transaction) { create(:transaction) }

    it "returns the requested transaction" do
      get "/api/v1/transactions/#{transaction.id}"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body).with_indifferent_access
      expect(json_response).to have_key(:transaction)
      expect(json_response[:transaction][:id]).to eq(transaction.id)
    end

    it "returns error when transaction not found" do
      get "/api/v1/transactions/999"
      expect(response).to have_http_status(:not_found)
    end
  end
end
