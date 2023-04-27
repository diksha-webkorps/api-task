# frozen_string_literal: true

Rails.application.routes.draw do
  # devise_for :users, controllers: {
  #   sessions: 'users/sessions',
  #   registrations: 'users/registrations'
  # }

  devise_for :users, controllers: { passwords: 'passwords',
                                    registrations: 'api/v1/registrations',
                                    sessions: 'api/v1/sessions',
                                    invitations: 'invitations' }

  namespace :api do
    namespace :v1 do
      resources :pages
    end
  end
end
