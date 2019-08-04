Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :likable do
    member do
      post :vote_up, :vote_down
      delete :cancel_vote
    end
  end

  resources :questions, concerns: :likable, shallow: true do
    resources :answers, concerns: :likable do
      member do
        patch :set_best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index
end
