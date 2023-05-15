Rails.application.routes.draw do
  mount EpiCas::Engine, at: "/"
  devise_for :users
  resources :course_modules, path: :modules do
    post :upload, on: :collection
  end
  resources :lsps, only: [:destroy] do
    get :upload, on: :collection
    post :confirm, on: :collection
    post :extract, on: :collection
  end
  resources :departments do
    get :get_modules, path: :modules, on: :member
    get :get_academics, path: :academics, on: :member
  end
  resources :students do
    post :upload, on: :collection
  end
  resources :academics
  resources :uploads

  resources :users do
    post :upload_users, on: :collection
  end

  match "/403", to: "errors#error_403", via: :all
  match "/404", to: "errors#error_404", via: :all
  match "/422", to: "errors#error_422", via: :all
  match "/500", to: "errors#error_500", via: :all

  get :ie_warning, to: 'errors#ie_warning'
  get :javascript_warning, to: 'errors#javascript_warning'

  root to: "students#index"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
