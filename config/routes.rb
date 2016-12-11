Rails.application.routes.draw do
  namespace :rain do
    root :to => 'admin#index', as: 'root'
    get 'admin/rapids' => 'admin#rapids', :as => 'admin_rapids'
    get 'admin/drops' => 'admin#drops', :as => 'admin_drops'
    resources :drops

    resources :rapids, :except => [:show]

    constraints :format => 'js' do
      get 'javascripts/rain.js' => 'javascripts#cloud', :as => 'cloud_js'
    end
  end

  # get '/*id' => 'rain/drops#cloud', :as => 'clouds'
end
