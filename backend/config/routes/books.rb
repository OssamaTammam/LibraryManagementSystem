#################### Books ####################
namespace :v1 do
  resources :books, only: [ :index, :show, :create, :update, :destroy ] do
    collection do
      post :borrow
      post :buy
      post :return
    end
  end
end
