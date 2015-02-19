Rails.application.routes.draw do

  devise_for :admins
  devise_for :users

  # for devise - must set root to something
  root to: "users#index"

  # get 'users/check' => 'users#pre_registration_form'

  resources :users

  ## all the custom routes in new rider year registration - nested resources associated with new r_y_r

  get 'rider_year_registrations/agree_to_terms' => 'rider_year_registrations#new_agree_to_terms' 
  post 'rider_year_registrations/agree_to_terms' => 'rider_year_registrations#create_agree_to_terms'

  get 'rider_year_registrations/persistent_rider_profile' => 'rider_year_registrations#new_persistent_rider_profile' 
  post 'rider_year_registrations/persistent_rider_profile' => 'rider_year_registrations#create_persistent_rider_profile'


  get 'rider_year_registrations/mailing_address' => 'rider_year_registrations#new_mailing_address' 
  post 'rider_year_registrations/mailing_address' => 'rider_year_registrations#create_mailing_address'  

  get 'rider_year_registrations/pay_reg_fee' => 'rider_year_registrations#new_pay_reg_fee' 
  post 'rider_year_registrations/pay_reg_fee' => 'rider_year_registrations#create_pay_reg_fee' 
  resources :rider_year_registrations

  get 'admin' => 'admin/admins#index'

  namespace :admin do
    resources :users
    resources :admins
    resources :ride_years
  end

  

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
