require 'rails_helper'

RSpec.describe "Api::V1::UsersController", type: :request do
  def clear_jwt_cookie
    cookies.delete("jwt")
  end

  describe "Operations on current user" do
    before do
      @test_user = create(:user)
      post "/api/v1/auth/login", params: {
        email: @test_user.email,
        password: TestConstants::DEFAULT_USER_PARAMS[:password]
      }
    end

    describe "GET /api/v1/users/me" do
      it "returns the current user" do
        get "/api/v1/users/me"

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body).with_indifferent_access
        expect(json_response).to have_key(:user)
        expect(json_response[:user][:id]).to eq(@test_user.id)
    end

      it "returns an error when user not found" do
        clear_jwt_cookie
        get "/api/v1/users/me"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "PUT /api/v1/users/me" do
      it "updates the current user" do
        put "/api/v1/users/me", params: {
          username: "updatedusername"
        }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body).with_indifferent_access
        expect(json_response).to have_key(:user)
        expect(json_response[:user][:username]).to eq("updatedusername")
        expect(@test_user.reload.username).to eq("updatedusername")
      end
    end

    describe "DELETE /api/v1/users/me" do
      it "deletes the current user" do
        delete "/api/v1/users/me"

        expect(response).to have_http_status(:no_content)
        expect(User.exists?(@test_user.id)).to be_falsey
      end
    end
  end

  # Standard user management endpoints
  describe "User management" do
    before do
      # Create an admin user
      admin = create(:user, admin: true)
      post "/api/v1/auth/login", params: {
        email: admin.email,
        password: TestConstants::DEFAULT_USER_PARAMS[:password]
      }
    end

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
end
