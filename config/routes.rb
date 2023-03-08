# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'bulletins#index'
    resources :bulletins

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'auth/logout', to: 'auth#logout'

    namespace :admin do
      # get '/', to: 'dashboard#index', as: :dashboard
      # resources :bulletins, only: :index do
      #   member do
      #     patch :archive
      #     patch :publish
      #     patch :reject
      #   end
      # end
      get '/', to: 'bulletins#index'
      get 'bulletins', to: 'bulletins#index', as: :bulletins
      resources :categories, except: %i[show]
      resources :users, only: %i[index destroy edit update]
    end
  end

  match '/404', via: :all, to: 'errors#not_found'
  match '/422', via: :all, to: 'errors#unprocessable_entity'
  match '/500', via: :all, to: 'errors#server_error'
end
