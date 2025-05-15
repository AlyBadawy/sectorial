Rails.application.routes.draw do
  mount Securial::Engine => "/securial", as: "securial"
end
