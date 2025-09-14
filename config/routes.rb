# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do

  # resources :room_assignments do
  #   member do
  #     delete :unassign
  #     post :assign
  #   end
  # end
 

resources :room_assignments do
  member do
    patch :unassign 
    patch :assign 
  end
  # This is the new part you need to add.
  collection do
    get :rooms_by_participant_type
  end
end

  # resources :public_participants, only: [:show], path: 'participants'

  
  resources :participants do
    collection do
      get :export, defaults: { format: 'xlsx' }
      post :import
      patch :update_visit_day_1 # Custom route for updating visit_day_1
      get 'detailed/:serial_number', to: 'participants#detailed', as: :detailed
      get 'printbadge/:serial_number', to: 'participants#printbadge', as: :printbadge
 
    end
  end

  resources :side_events
  resources :field_visit_activities
  resources :field_visit_areas
  resources :groups
  resources :participant_types
  resources :organizations  do
    post :create_from_form, on: :collection
  end
  resources :rooms do
    resources :room_assignments 
  end
  resources :hotels
  resources :attendees

  resources :admin_participants do
    member do
      patch :approve
      patch :reject   
      post :send_badge_email
    end
  end


  draw :accounts
  draw :api
  draw :billing
  draw :turbo_native
  draw :users
  draw :dev if Rails.env.local?

  authenticated :user, lambda { |u| u.admin? } do
    draw :admin
  end


  resources :announcements, only: [:index, :show]

  namespace :action_text do
    resources :embeds, only: [:create], constraints: {id: /[^\/]+/} do
      collection do
        get :patterns
      end
    end
  end
  namespace :admin do
    resources :participants do
      member do
        patch :approve
        patch :reject
        patch :mark_attended
      end
    end

    
  end

  scope controller: :static do
    get :about
    get :terms
    get :privacy
    get :pricing
  end

  match "/404", via: :all, to: "errors#not_found"
  match "/500", via: :all, to: "errors#internal_server_error"

  authenticated :user do
    root to: "dashboard#show", as: :user_root
    get 'dashboard/badges_pdf', to: 'dashboard#badges_pdf', as: 'badges_pdf'
    get 'dashboard/index', to: 'dashboard#index', as: 'index'
    get 'dashboard/doubled', to: 'dashboard#doubled', as: 'doubled'
    
    get 'dashboard/doubled_participant/:id', to: 'dashboard#doubled_participant', as: 'doubled_participant'
    
    get 'dashboard/download_pdf/:id', to: 'dashboard#download_pdf', as: 'download_badge_pdf', constraints: { format: :pdf }


    # Alternate route to use if logged in users should still see public root
    # get "/dashboard", to: "dashboard#show", as: :user_root
  end

  
  get 'custom_error', to: 'static_pages#not_found', as: 'custom_error'


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Public marketing homepage
  root to: "static#index"
end
