Rails.application.routes.draw do
  root to: 'pages#home'

  devise_for :customers, controllers: {
    sessions: 'customer/sessions',
    registrations: 'customer/registrations'
  }
  devise_for :admins, controllers: {
    sessions: 'admin/sessions'
  }, skip: [:registrations]

  namespace :admin do
    root to: 'pages#home'
    resources :products, only: %i[index show new create edit update destroy]
    resources :orders, only: %i[show update]
    resources :customers, only: %i[index show]
    resources :articles
  end
  scope module: :customer do
    resources :products, only: %i[index show]
    resources :cart_items, only: %i[index create destroy update]
    resources :orders, only: %i[create show index]
    resources :articles, only: %i[index show]
    resources :contacts, only: %i[new create]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  mount ActiveStorage::Engine => '/rails/active_storage'

  # カスタムエラーページ用のルート
  get '/404', to: 'errors#not_found', as: :not_found
  get '/500', to: 'errors#internal_server_error', as: :internal_server_error

# カスタムエラーハンドリング
match '*path', to: 'errors#not_found', via: :all, constraints: ->(req) {
  !req.path.start_with?('/rails/active_storage')
}
end
