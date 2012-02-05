People::Application.routes.draw do             
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  # Систему аутентификации обрабатываем своим контроллером
  devise_for :users, :controllers => {:sessions => 'sessions', :omniauth_callbacks => "users/omniauth_callbacks" }  
  
  root :to => "main#index"

  resources :users do
     resources :messages
  end
  resources :sessions
  resources :missings 
  resources :searches
                                  
  match "add_missing" => "missings#new"
  match "add_missing/save_step" => "missings#save_step"
  match "add_missing/places" => "missings#places"
  match "add_missing/address_suggest" => "missings#address_suggest"
  match "add_missing/address_data" => "missings#address_data"
  match "add_missing/answer_the_question" => "missings#answer_the_question"
  match "add_missing/:step" => "missings#new"              
                                                                       
  match "missing/add_comment" => "missings#add_comment"      
  match "missings/:id/print" => "missings#print"
  match "seen_the_missing" => "missings#i_seen_the_missing"

  match "report" => "report#report"
 
  match "users/send_message" => "messages#create"
  
  match ":action" => "static#:action"
   
end
