Securial::Engine.routes.draw do
  defaults format: :json do
    get "/status", to: "status#show", as: :status

    scope Securial.admin_namespace do
      resources :roles
      resources :users
      namespace :role_assignments, as: "role_assignments" do
        post "assign", action: :create, as: "assign"
        delete "revoke", action: :destroy, as: "revoke"
      end
    end

    scope "accounts" do
      get "me", to: "accounts#me", as: :me
      get "account/:username", to: "accounts#show", as: :account_by_username
      post "register", to: "accounts#register", as: :register
      put "update", to: "accounts#update_profile", as: :update_profile
      # post "update_avatar", to: "accounts#update_avatar"
      # post "update_notification_settings", to: "accounts#update_notification_settings"
      delete "delete_account", to: "accounts#delete_account", as: :delete_account
    end

    scope "sessions" do
      get "", to: "sessions#index", as: :index_sessions
      get "current", to: "sessions#show", as: :current_session
      get "id/:id", to: "sessions#show", as: :session
      post "login", to: "sessions#login", as: :login
      delete "logout", to: "sessions#logout", as: :logout
      put "refresh", to: "sessions#refresh", as: :refresh_session
      delete "revoke", to: "sessions#revoke", as: :revoke_current_session
      delete "id/:id/revoke", to: "sessions#revoke", as: :revoke_session_by_id
      delete "revoke_all", to: "sessions#revoke_all", as: :revoke_all_sessions
    end

    scope "password" do
      post "forgot", to: "passwords#forgot_password", as: :forgot_password
      put "reset", to: "passwords#reset_password", as: :reset_password
    end
  end
end
