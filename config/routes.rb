Rails.application.routes.draw do
  root 'questions#index'
  devise_for :users

  resources :users, only: [:index, :show, :destroy, :update]

  concern :commentable do
    resources :comments, except: [:show, :new, :index]
  end

  resources :questions, concerns: :commentable, shallow: true do
    member do
      patch 'update_vote'
    end
    resources :answers, concerns: :commentable,
              only: [:create, :update, :edit, :destroy] do
      member do
        patch 'update_vote'
        patch 'update_accept_status'
      end
    end
  end
  match '*path', to: 'application#routing_error', via: :all
end
