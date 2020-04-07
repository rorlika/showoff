Rails.application.routes.draw do
  get 'user_widgets/index'
  root to: 'widgets#index'

  resources :widgets, only: %i[create index] do
    collection do
      post 'search'
    end
  end

  resources :user_widgets, only: :create do
    collection do
      get 'index_me'
    end
  end

  scope :users do
    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    get '/logout', to: 'sessions#destroy'
  end

  resources :users, only: %i[create show] do
    collection do
      post 'reset_password'
    end
  end
end
