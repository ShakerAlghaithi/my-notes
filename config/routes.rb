Rails.application.routes.draw do

   resources :notes,  :sessions, :users  
   root 'users#index'
   
   get "/signin", to: "sessions#new"
   post "/sessions", to: "sessions#create"
   get "/signup", to: "users#new"
   delete '/signout', to: 'sessions#destroy'
   get "/auth/:provider/callback" => "notes#index"
end

