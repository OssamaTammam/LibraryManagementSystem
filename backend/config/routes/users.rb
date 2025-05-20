#################### users ####################
namespace :v1 do
  resources :users, controller: "users", only: [ :index, :show, :update, :destroy ] do
    collection do
      get :me
      put :update_me
      delete :delete_me
    end
  end
end
