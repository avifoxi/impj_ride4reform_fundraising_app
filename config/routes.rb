Rails.application.routes.draw do

  devise_for :admins
  devise_for :users

  # for devise - must set root to something
  # root to: "persistent_rider_profiles#index"

  root to: "static_pages#home_page"

  get 'donors' => 'static_pages#donors'
  get '/site_is_not_active' => 'static_pages#site_is_not_active'


  # donations new nested under riders, and ALSO without nesting. 
  # if nested under rider-- donate to rider
  # if no rider spec'd, donate to org

  resources :persistent_rider_profiles, :path => "riders" do
    post '/deactivate'=> 'persistent_rider_profiles#deactivate_current_ryr', as: :deactivate_current_ryr
    post '/reactivate'=> 'persistent_rider_profiles#reactivate_current_ryr', as: :reactivate_current_ryr

    resources :donations, only: [:new, :create, :index]
    resources :rider_year_registrations, only: :new
  end
  resources :donations, only: [:new], as: :donation_to_organization

  resources :donations, only: [:create, :edit, :update, :destroy]

  resources :mailing_addresses, except: [:show, :index]

  
  get 'donations/:id/new_donation_payment' => 'donations#new_donation_payment', as: :new_donation_payment
  post 'donations/:id/create_donation_payment' => 'donations#create_donation_payment', as: :create_donation_payment

  # resources :persistent_rider_profiles, :path => "riders"

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
    resources :users do 
      resources :rider_year_registrations, only: [:new, :create]
      resources :mailing_addresses, only: [:new, :create]
    end
    resources :admins
    resources :ride_years do
      resources :donations, only: :index
      resources :rider_year_registrations, only: :index
      resources :custom_ride_options, only: [:new, :create, :index]
    end
    resources :custom_ride_options, only: [ :update, :destroy, :edit ]
    resources :donations
    resources :mailing_addresses, except: [:show, :index, :new, :create]
    
    resources :rider_year_registrations, except: [:new, :create] do 
      post '/deactivate'=> 'rider_year_registrations#deactivate', as: :deactivate
      post '/reactivate'=> 'rider_year_registrations#reactivate', as: :reactivate

    end

    get 'donations/:id/new_donation_payment' => 'donations#new_donation_payment', as: :new_donation_payment

    post 'donations/:id/create_donation_payment' => 'donations#create_donation_payment', as: :create_donation_payment
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
