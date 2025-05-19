#################### Auth ####################
namespace :v1 do
  resource :auth, controller: "auth", only: [] do
    post :login
    post :signup
  end
end
