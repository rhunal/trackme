Rails.application.routes.draw do

  concern :importable do
    get 'download_sample', on: :collection
    get 'import', on: :collection
    post 'import_post', on: :collection
  end

  resources :cities, concerns: [:importable]
  resources :countries, concerns: [:importable]
  devise_for :users

  get 'visitors/cities/:country', to: 'visitors#cities'

  resources :visitors, only: [:new, :index] do
    collection do
      post 'submit'
    end
  end

  root to: 'visitors#index'  
end
