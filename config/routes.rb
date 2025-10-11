Rails.application.routes.draw do
  # devise_for :users
  # devise_for :users, controllers: {
  #   registrations: 'users/registrations',
  #   sessions: 'users/sessions'
  # }

  # config/routes.rb
  devise_for :users,
    controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions',

      
    }




  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  devise_scope :user do
    patch '/users/change_password', to: 'users/registrations#change_password'
  end
  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      # resources :payment_details, only: [:create, :index, :show]
      # resource :certificate, only: [:show]
      # resources :certificates, only: [:show]
      # resources :certificates, only: [:show], defaults: { format: :pdf }
      resources :certificates, only: [:show]
      # get "/test_pdf", to: "certificates#test_pdf"
      # get "certificate/:id", to: "certificates#test_pdf"
      get 'certificate/:id', to: 'certificates#test_pdf', defaults: { format: :pdf }
      get '/show_details', to: 'certificates#show_details'
      get '/user_details', to: 'certificates#user_details'
      resources :transactions, only: [:show]
      post "upload_transactions/:id", to: "transactions#upload"
      get 'profile', to: 'profiles#show'
      patch 'profile', to: 'profiles#update'

      resources :notifications, only: [:index, :create] do
        member do
          patch :read, to: 'notifications#mark_as_read'
        end
      end

      resources :admin_notifications, only: [:index] do
        member do
          patch :read, to: 'admin_notifications#mark_as_read'
          patch :update_payout_day, to: 'admin_notifications#upcoming_payouts'
        end
      end

    end
  end

end
