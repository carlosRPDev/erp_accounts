# frozen_string_literal: true

ErpAccounts::Engine.routes.draw do
  resources :accounts do
    member do
      get :settings
      get :modules
    end
  end
end
