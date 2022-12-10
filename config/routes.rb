Rails.application.routes.draw do
  devise_for :users

  root to: 'users#index'

  resources :users do
    resources :accounts do
      resources :transactions do
        collection do
          get  'extract'
          post 'deposit'
          post 'withdraw'
          post 'transfer'
        end
      end
    end
  end
end
