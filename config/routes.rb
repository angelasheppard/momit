Rails.application.routes.draw do
 
  get 'static_pages/home'
  match '/code-of-conduct', to: 'static_pages#code_of_conduct', via: [:get]
  match '/guild-policies', to: 'static_pages#guild_policies', via: [:get]
  
  devise_for :users, path_names: {sign_in: 'login', sign_out: 'logout'}

  root 'static_pages#home'
end
