Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: "questions#index"

  resources :users do
    member do
      get :set_email
      patch :confirm_email
    end
  end

  concern :likable do
    member do
      post :vote_up, :vote_down
      delete :cancel_vote
    end
  end

  concern :commentable do
    resources :comments, shallow: true
  end

  resources :questions, concerns: %i[likable commentable], shallow: true do
    resources :answers, concerns: %i[likable commentable] do
      member do
        patch :set_best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end

      resources :questions, shallow: true, except: %i[new] do
        resources :answers, only: %i[index show]
      end
    end
  end

  mount ActionCable.server => '/cable'
end
