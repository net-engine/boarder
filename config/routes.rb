Boarder::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  mount_sextant if Rails.env.development?

  root to: 'dashboard#index'
end
