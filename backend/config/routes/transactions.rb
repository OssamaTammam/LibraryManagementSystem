#################### transactions ####################
namespace :v1 do
  resources :transactions, controller: "transactions", only: [ :index, :show ] do
  end
end
