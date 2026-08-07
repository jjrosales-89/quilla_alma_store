Rails.application.routes.draw do
  devise_for :customers
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

  post "stripe/webhook",
      to: "stripe_webhooks#create",
      as: :stripe_webhook

  patch "cart/items/:product_id",
        to: "carts#update",
        as: :update_cart_item

  delete "cart/items/:product_id",
        to: "carts#destroy",
        as: :remove_cart_item

  resource :checkout,
            only: %i[show create]

  get "checkout/success",
      to: "checkouts#success",
      as: :checkout_success

  get "checkout/cancel",
      to: "checkouts#cancel",
      as: :checkout_cancel

  resources :orders,
            only: %i[index show]

  get "up" => "rails/health#show", as: :rails_health_check
end
