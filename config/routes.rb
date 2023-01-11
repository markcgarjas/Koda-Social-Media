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
    resources :user_groups
  end
end
