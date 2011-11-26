People::Application.routes.draw do             
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  # Систему аутентификации обрабатываем своим контроллером
  devise_for :users, :controllers => {:sessions => 'sessions', :omniauth_callbacks => "users/omniauth_callbacks" }  
  
  root :to => "main#index"
  
  resources :users
  resources :sessions
  resources :missings 
                                  
  match "missings_list" => "lost_list#index"
  match "missings_list/:type" => "lost_list#index"
  match "add_missing" => "missings#new"
  match "add_missing/save_step" => "missings#save_step"
  match "add_missing/places" => "missings#places"
  match "add_missing/address_suggest" => "missings#address_suggest"
  match "add_missing/address_data" => "missings#address_data"
  match "add_missing/:step" => "missings#new"             
                                                                       
  match "missing/add_comment" => "missings#add_comment"      
  match "missings/:missing_id/i_can_help" => "missings#i_can_help"    
  
  match "inbox" => "report#inbox"             
  match "report" => "report#report"
  match "send_message" => "users#send_message"      
  
   
end