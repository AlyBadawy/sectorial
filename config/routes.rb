Securial::Engine.routes.draw do
  defaults format: :json do
    get "/status", to: "status#show", as: :status

    scope Securial.admin_namespace do
      # Placeholder for admin-specific routes. Add routes here as needed.
      # For example:
      # resources :users, only: [:index, :show]
      resources :roles
      resources :users
    end
  end
end
