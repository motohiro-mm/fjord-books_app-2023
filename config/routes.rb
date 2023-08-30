Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users
  root to: 'books#index'
  resources :books do
    resources :comments, only: %i(edit create update destroy), module: :books
  end
  resources :reports do
    resources :comments, only: %i(edit create update destroy), module: :reports
  end
  resources :users, only: %i(index show)
end
