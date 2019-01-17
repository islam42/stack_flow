Rails.application.routes.draw do
  root 'questions#index'
  devise_for :users

  resources :users, only: %i[index show destroy] do
    put 'activate_deactivate', on: :member
  end

  concern :commentable do
    resources :comments, except: %i[show new index]
  end

  resources :questions, concerns: :commentable, shallow: true do
    collection do
      get 'answered'
      get 'asked_last_week'
      get 'un_answered'
      get 'accepted'
      get 'search'
    end
    member do
      put 'upvote'
      put 'downvote'
    end
    resources :answers, only: %i[create update] do
      member do
        put 'upvote'
        put 'downvote'
        put 'accept'
        put 'reject'
      end
    end
  end
  resources :answers, only: %i[edit destroy], concerns: :commentable,
                      shallow: true

  match '*path', to: 'application#routing_error', via: :all
end
