Rails.application.routes.draw do
  resources :pages, except: [:show]
  get '/pages/:permalink' => "pages#permalink", as: 'permalink'
  root to: 'home#index'
  # get 'production_companies/index'
  # get 'production_companies/show'
  # get 'movies/index'
  # get 'movies/show'
  resources :movies, only: [:index, :show] do
    collection do
      get "search"
    end
  end
  resources :production_companies, only: [:index, :show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
