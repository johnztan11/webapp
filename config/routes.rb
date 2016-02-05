Rails.application.routes.draw do
  get 'landings/index'
  get 'directories/aboutus', :as => 'aboutus_page'

  resources :documents
  resources :transactions, only: [:create]

  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords"}
  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  devise_scope :user do
    root to: 'users/registrations#new'
  end

  resources :authors, only: [:edit, :update]
 
end
