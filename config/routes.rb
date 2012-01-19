Rails.application.routes.draw do
  namespace :rain do
    root :to => 'admin#index'
    match 'admin/rapids' => 'admin#rapids', :as => 'admin_rapids'
    match 'admin/drops' => 'admin#drops', :as => 'admin_drops'
    resources :drops do
      member do
        get 'previous'
        get 'next'
        get 'history'
        get 'revert_to'
      end
    end
    match 'clouds/:name/edit' => 'clouds#edit', :as => 'edit_cloud'

    resources :clouds do
      member do
        get 'previous'
        get 'next'
        get 'history'
        get 'revert_to'
      end
    end
    resources :rapids, :except => [:show]

    constraints :format => 'js' do
      match 'javascripts/rain.js' => 'javascripts#cloud', :as => 'cloud_js'
    end
  end

  match '/:id' => 'rain/clouds#cloud', :as => 'clouds'
end
