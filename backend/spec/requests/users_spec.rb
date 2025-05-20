require 'rails_helper'

RSpec.describe "Api::V1::UsersController", type: :request do
  before do
    stub_const('Constants', TestConstants) unless defined?(Constants)

    # Create a user and set up authentication
    @current_user = create(:user)

    # Allow Pundit
    allow_any_instance_of(Api::V1::UsersController).to receive(:authorize).and_return(true)

    # Set up the current_user for the controller
    allow_any_instance_of(Api::V1::UsersController).to receive(:authenticate_request!).and_return(true)
    # Directly set the instance variable
    allow_any_instance_of(Api::V1::UsersController).to receive(:instance_variable_get).with('@current_user').and_return(@current_user)
  end

  # Standard user management endpoints
  describe "GET /api/v1/users" do
    before do
      # Create some additional users
      create_list(:user, 3)
    end

    it "returns a list of all users" do
      get "/api/v1/users"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body).with_indifferent_access
      expect(json_response).to have_key(:users)
    end
  end

  describe "GET /api/v1/users/:id" do
    let(:user) { create(:user) }

    it "returns a specific user" do
      get "/api/v1/users/#{user.id}"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body).with_indifferent_access
      expect(json_response).to have_key(:user)
      expect(json_response[:user][:id]).to eq(user.id)
    end

    it "returns an error when user not found" do
      get "/api/v1/users/999"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PUT /api/v1/users/:id" do
    let(:user) { create(:user) }

    it "updates a specific user" do
      put "/api/v1/users/#{user.id}", params: {
        username: "updatedusername",
        email: "updatedemail@example.com",
        admin: true
      }

      expect(response).to have_http_status(:ok)
      expect(user.reload.username).to eq("updatedusername")
      expect(user.reload.email).to eq("updatedemail@example.com")
      expect(user.reload.admin).to eq(true)
    end

    it "returns an error when user not found" do
      put "/api/v1/users/999", params: { username: "test" }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /api/v1/users/:id" do
    let!(:user) { create(:user) }

    it "deletes a specific user" do
      expect {
        delete "/api/v1/users/#{user.id}"
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns an error when user not found" do
      delete "/api/v1/users/999"
      expect(response).to have_http_status(:not_found)
    end
  end
end
