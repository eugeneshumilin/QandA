Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions, shallow: true do
    resources :answers do
      member do
        patch :set_best
      end
    end
  end

  resources :attachments, only: :destroy
end

