Rails.application.routes.draw do

  post 'trip-:url/add-:food/address-:address' => 'ideas#add_yelp', as: :add_yelp

  #get 'trips/trip-:url/yelp_results' => 'trips#yelp_results', as: 'yelp_results'   
  get 'trip-:url/invite' => 'group_trips#invite', as: :invite_friend
  post 'trip-:url/invite' => 'group_trips#send_invite'
  patch 'trip-:url/:response' => 'group_trips#rsvp', as: :rsvp
  get 'invites' => 'group_trips#invites', as: :invites

  delete 'trip-:url/leave' => 'group_trips#leave_trip', as: :leave_trip
  delete 'trip-:url/uninvite-:tag' => 'group_trips#uninvite', as: :uninvite

  get 'trip-:url/find-food' => 'trips#find_food', as: :find_food
  delete 'trip-:url/delete' => 'trips#destroy', as: :delete_trip
  get 'trip-:url' => 'trips#show', as: :trip
  get 'trip-:url/edit' => 'trips#edit', as: :edit_trip
  post 'trip-:url/edit' => 'trips#update'
  get 'trips/new' => 'trips#new', as: :new_trip
  post 'trips/new' => 'trips#create'
  
  get 'dashboard' => 'users#show', as: :dashboard
  get 'account' => 'users#edit', as: :account
  patch 'account' => 'users#update'

  post 'trip-:url' => 'ideas#create', as: :new_idea
  get 'trip-:url/idea-:id' => 'ideas#show', as: :idea
  put 'trip-:url/idea-:id/edit' => 'ideas#update', as: :edit_idea
  delete 'trip-:url/idea-:id/delete' => 'ideas#destroy', as: :delete_idea
  get 'trip-:url/ideas' => 'ideas#index'

  get 'signup' => 'users#new', as: :signup
  post 'signup' => 'users#create'
  get 'login' => 'users#login', as: :login  
  post 'login' => 'users#authenticate'
  delete 'logout' => 'users#logout', as: :logout
 
  get 'password_reset' => 'password_resets#new', as: :password_reset
  post 'password_reset' => 'password_resets#create'
  get 'password_reset/:token' => 'password_resets#edit', as: :confirm_reset
  patch 'password_reset/:token' => 'password_resets#update'

  resources :users do 
    resources :trips, only: [:show, :delete] do 
      resources :ideas, only: [:show, :delete]
    end
  end

  root 'home_pages#home'


  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
