Rails.application.routes.draw do

  get 'static_pages/home'
  match '/code-of-conduct', to: 'static_pages#code_of_conduct', via: [:get]
  match '/guild-policies', to: 'static_pages#guild_policies', via: [:get]

	match '/users', to: 'users#index', via: 'get'

  devise_for :users,
    controllers: {
      confirmations: 'users/confirmations',
      registrations: 'users/registrations',
    },
    path_names: {
      sign_in: 'login',
      sign_out: 'logout'
    }

  scope "/admin" do
    resources :users
  end

  root 'static_pages#home'
end
