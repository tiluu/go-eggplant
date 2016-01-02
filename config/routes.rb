Rails.application.routes.draw do
  #get 'trips/trip-:url/yelp_results' => 'trips#yelp_results', as: 'yelp_results'   
  get 'trip-:url/invite' => 'group_trips#invite', as: :invite_friend
  post 'trip-:url/invite' => 'group_trips#send_invite'
  #get 'trip-:url' => 'group_trips#show_group', as: :group_trip
  patch 'trip-:url/:response' => 'group_trips#rsvp', as: :rsvp

  delete 'trip-:url/leave' => 'group_trips#leave_trip', as: :leave_trip
  delete 'trip-:url/uninvite-:tag' => 'group_trips#uninvite', as: :uninvite

  get 'trip-:url/find_food' => 'trips#find_food', as: :find_food
  get 'trip-:url' => 'trips#show', as: :trip
  get 'trip-:url/edit' => 'trips#edit', as: :edit_trip
  post 'trip-:url/edit' => 'trips#update'
  get 'trips/new' => 'trips#new', as: :new_trip
  post 'trips/new' => 'trips#create'
  
  get 'dashboard' => 'users#show', as: :dashboard
  get 'account' => 'users#edit', as: :account
  patch 'account' => 'users#update'
  
  #get 'user/trip-:url/ideas/new' => 'ideas#new'
  post 'trip-:url' => 'ideas#create', as: :new_idea
  get 'trip-:url/idea-:id' => 'ideas#show', as: :idea
  get 'trip-:url/idea-:id/edit' => 'ideas#edit', as: :edit_idea
  post 'trip-:url/idea-:id/edit' => 'ideas#update'
  get 'trip-:url/ideas' => 'ideas#index'

  get 'signup' => 'users#new', as: :signup
  post 'signup' => 'users#create'
  get 'login' => 'users#login', as: :login  
  post 'login' => 'users#authenticate'
  delete 'logout' => 'users#logout', as: :logout
 

  resources :users do 
    resources :trips, only: [:show, :delete] do 
      resources :ideas, only: [:show, :delete]
    end
  end


  root 'home_pages#home'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
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
