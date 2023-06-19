Rails.application.routes.draw do
  mount Aypex::AuthDevise::Engine => "/aypex-auth_devise"
end
