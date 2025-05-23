#################### users ####################
namespace :v1 do
  resources :users, controller: "users", only: [ :index, :show, :update, :destroy ] do
    collection do
      get :me
      put :me, action: :update_me
      delete :me, action: :delete_me
      get "me/borrowed_books", action: :get_borrowed_books
      get "me/transactions", action: :get_transactions
    end
  end
end
