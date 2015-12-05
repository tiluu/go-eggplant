Rails.application.routes.draw do
  get 'trips/trip-:url/yelp_results' => 'trips#yelp_results', as: 'yelp_results'   
  get 'user/trip-:url' => 'trips#show', as: :trip
  get 'user/trip-:url/edit' => 'trips#edit', as: :edit_trip
  get 'user/trips/new' => 'trips#new', as: :new_trip
  get 'user/dashboard' => 'users#show', as: :dashboard
  
  get 'user/trip-:url/ideas/new' =>'ideas#new', as: :new_idea   
  post 'user/trip-:url/ideas/new' => 'ideas#create'
  get 'user/trip-:url/ideas/:id' => 'ideas#show', as: :idea
  #post 'user/trip-:url' => 'trips#show'

  get 'signup' => 'users#new', as: :signup
  get 'login' => 'users#login', as: :login  
  post 'login' => 'users#authenticate'
  delete 'logout' => 'users#logout', as: :logout
 

  resources :users do
    resources :trips, except: :index do
        resources :ideas, except: :index
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
