Rails.application.routes.draw do
  root to: "questions#index"

  resources :questions, shallow: true do
    resources :answers
  end
end

