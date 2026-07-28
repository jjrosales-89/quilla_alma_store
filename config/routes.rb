Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root "products#index"

  resources :products, only: %i[index show]
  resources :categories, only: %i[index show]

  # Sesssion-based shopping cart routes
  get "cart", to: "carts#show", as: :cart

  post "cart/items/:product_id",
      to: "carts#add",
      as: :add_cart_item

  patch "cart/items/:product_id",
        to: "carts#update",
        as: :update_cart_item

  delete "cart/items/:product_id",
        to: "carts#destroy",
        as: :remove_cart_item

  get "up" => "rails/health#show", as: :rails_health_check
end
