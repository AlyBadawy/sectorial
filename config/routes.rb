Securial::Engine.routes.draw do
  defaults format: :json do
    get "/status", to: "status#show", as: :status

    namespace Securial.admin_namespace do
    end
  end
end
