Aypex::Engine.routes.draw do
  scope "(:locale)", locale: /#{Aypex.available_locales.join('|')}/, defaults: {locale: nil} do
    devise_for :aypex_user,
      path: :accounts,
      class_name: Aypex::Config.user_class.to_s,
      router_name: :aypex,
      module: "aypex/auth_devise",
      skip: [:unlocks, :omniauth_callbacks]

    if Aypex::Engine.storefront_available?
      resource :account, only: [:show, :edit, :update], controller: :users do
        patch :update_password
      end
    end

    devise_scope :aypex_user do
      get :unauthorized, to: "sessions#unauthorized", as: :unauthorized
    end

    if Aypex::Engine.api_available?
      namespace :api, defaults: {format: :json} do
        namespace :v2 do
          namespace :storefront do
            resource :account, controller: :account, only: %i[show create update]
            resources :account_confirmations, only: %i[show]
            resources :passwords, controller: :passwords, only: %i[create update]
          end
        end
      end
    end
  end
end
