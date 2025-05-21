#################### users ####################
namespace :v1 do
  resources :users, controller: "users", only: [ :index, :show, :update, :destroy ] do
    collection do
      get :me
      put :me, action: :update_me
      delete :me, action: :delete_me
    end
  end
end
