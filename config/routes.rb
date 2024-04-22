Rails.application.routes.draw do
  get 'settings/index'
  get 'historico/index'
  resources :valordoses
  get 'static_pages/inadimplente'
  root 'welcome#index'
  get 'admin', to: 'admin#index'
  get 'dadosuser', to: 'admin#dadosuser'
  get '/manager_users', to: 'manager_users#index', as: 'manager_users_index'
  get 'inadimplente', to: 'static_pages#inadimplente'
  resources :employees
  devise_for :users
  resources :keylockers 
  get 'historico', to: 'historico#index'
  get '/atualizar_soma_dinamica', to: 'keylockers#atualizar_soma_dinamica'

  get '/dispensers', to: 'keylockers#index', as: 'dispensers'
  get '/user_dispenser', to: 'manager_users#index', as: 'user_dispenser'
  get '/dispensers/new', to: 'keylockers#new', as: 'new_dispenser'

  get '/dispensers/:id', to: 'keylockers#show', as: 'dispenser', constraints: { id: /\d+/ }
  get '/dispensers/:id/edit', to: 'keylockers#edit', as: 'edit_dispenser', constraints: { id: /\d+/ }
  post 'user_mailer/send_email', to: 'user_mailer#send_email'
  post '/enviar_mensagem_whatsapp/:id', to: 'employees#enviar_mensagem_whatsapp', as: 'enviar_mensagem_whatsapp'


  resources :settings, only: [:index, :create]

  resources :employees do
    member do
      patch 'toggle_and_save_status'
      put 'reset_pin'
      post 'employees/send_email', to: 'employees#send_email'
      post 'send_email'
      post 'send_sms'
      post 'import', to: 'employees#import'
    end
    collection do
      post 'import', to: 'employees#import'
    end
  end

  resources :keylockers do
    member do
      post 'reset_counter'
      patch 'toggle_and_save_status'
    end
  end

  patch 'manager_users/:id/toggle_finance', to: 'manager_users#toggle_finance', as: :toggle_finance
  patch 'manager_users/:id/toggle_role', to: 'manager_users#toggle_role', as: :toggle_role

  resources :manager_users do
    member do
      delete :destroy
    end
  end

  get '/history_entries', to: 'history_entries#index'

  resources :addresses, only: [:new, :create, :edit, :update, :destroy]

  resources :history_entries, only: [:index, :show, :new, :create, :destroy]


  # config/routes.rb
  resources :user_lockers do
    member do
      post 'assign_keylocker'
      delete 'remove_keylocker/:keylocker_id', to: 'user_lockers#remove_keylocker', as: 'remove_keylocker'
    end
  end

  

  #resources :keylockers, defaults: { format: 'json' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      resources :employees
      post 'employees/check_access', to: 'employees#check_access'
      get '/employees', to: 'employees#index'
      post '/register_card', to: 'employees#register_card'
      post '/create_user', to: 'employees#create_user'
      get '/employees/:employee_id/belongs_to_keylocker/:keylocker_id', to: 'employees#belongs_to_keylocker'
      post '/libera_dose', to: 'employees#libera_dose', via: :post
      post 'check_user', to: 'employees#check_user'
      post 'count_and_track_spaces', to: 'employees#count_and_track_spaces'
      post 'return_key', to: 'employees#return_key'
      post 'key_locker_history', to: 'employees#key_locker_history'
      get '/outro_metodo', to: 'employees#outro_metodo'
      resources :keylockers do
        member do
          post 'increment_counter'
        end
      end
      #post '/auth/sign_in', to: 'authentication#sign_in'
      devise_for :users, skip: [:registrations], controllers: {
        sessions: 'api/v1/auth/sessions'
      }
    end
  end
end


