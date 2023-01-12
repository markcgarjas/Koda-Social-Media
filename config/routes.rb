Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "posts#index"
  resources "posts" do
    resources "comments", except: :show
  end
  resources "user_post_lists"
  resources :friend_requests
  resources :friends
  resources :groups do
    post "join_group", to: "groups#join_group"
    put "cancel", to: "groups#cancel"
    resources :user_groups do
      put "approve", to: "user_groups#approve"
      delete "decline", to: "user_groups#decline"
    end
  end
end
