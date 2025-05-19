Rails.application.routes.draw do
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "health" => "health_check#show", as: :health_check
  get "ready" => "health_check#dependencies", as: :ready_check

  api_path = Rails.env.development? || Rails.env.test? ? "api" : ""
  namespace(:api, path: api_path) do
    # draw(:auth)
    # draw(:books)
    # draw(:users)
    # draw(:transactions)
  end
end
