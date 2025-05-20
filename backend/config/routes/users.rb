#################### users ####################
namespace :v1 do
  resources :users, controller: "users", only: [ :index, :show, :update, :destroy ] do
    collection do
      get :me
      put :me
      delete :me
    end
  end
end
