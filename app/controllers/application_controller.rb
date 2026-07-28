class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Makes the cart count available in layouts and views.
  helper_method :cart_item_count

  private

    # Stores product IDs and quantities in the user's session.
    def cart
      session[:cart] ||= {}
    end

    def cart_item_count
      cart.values.sum { |quantity| quantity.to_i }
    end
end
