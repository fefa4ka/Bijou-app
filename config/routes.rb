People::Application.routes.draw do             
  ActiveAdmin.routes(self)

  root :to => "main#index"

  devise_for :admin_users, ActiveAdmin::Devise.config

  # Систему аутентификации обрабатываем своим контроллером
  devise_for :users, :controllers => { :sessions => 'users/sessions', 
    :registrations => "users/registrations",
    :confirmations => "users/confirmations",
    :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    match "sessions/new" => "sessions#new"
  end

  
  resources :sessions
  
  namespace :missings do
    resources :new do
      get 'search_for_similar', :on => :collection
    end
  end 

  resources :search
  resources :missings, :module => "missings" do
    match "print"
    match "questions"
  end
  
  get 'service/suggest_address'
  get 'service/check_email_exist'

  # match "add_missing" => "missings#new"                   
  # match "add_missing/search_for_similar" => "missings#search_for_similar"
  # match "add_missing/save_step" => "missings#save_step"
  # match "add_missing/places" => "missings#places"
  # match "add_missing/address_suggest" => "missings#address_suggest"
  # match "add_missing/address_data" => "missings#address_data"
  # match "add_missing/:step" => "missings#new"              
                                                                       
  match "missing/add_comment" => "missings#add_comment"      
  # match "missings/:id/print" => "missings#print"
  # match "missings/:id/questions" => "missings#questions"   
  # match "missings/:id/answer_the_question" => "missings#answer_the_question"
  # match "seen_the_missing" => "missings#i_seen_the_missing"

  match "report" => "report#index"
 
  match "users/settings" => "users#edit"
  match "users/send_message" => "messages#create"
  match "users/check_email" => "users#check_email"
  resources :users do
     resources :messages    
  end 
  
  match ":action" => "static#:action"
   
end
