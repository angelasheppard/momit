Rails.application.routes.draw do
 
  get 'static_pages/home'
  match '/code-of-conduct', to: 'static_pages#code_of_conduct', via: [:get]
  match '/guild-policies', to: 'static_pages#guild_policies', via: [:get]
  
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
end
