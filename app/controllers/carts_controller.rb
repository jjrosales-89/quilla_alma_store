class CartsController < ApplicationController
  def show
    # Loads all cart products with one database query.
    products = Product
      .where(id: cart.keys)
      .index_by { |product| product.id.to_s }

    # Combines each product with its saved session quantity.
    @cart_items = cart.filter_map do |product_id, quantity|
      product = products[product_id]

      next unless product

      {
        product: product,
        quantity: quantity.to_i
      }
    end
  end

  def add
    product = Product.find(params[:product_id])

    requested_quantity = normalized_quantity
    current_quantity = cart.fetch(product.id.to_s, 0).to_i
    available_quantity = product.stock_quantity - current_quantity

    # Prevents the cart quantity from exceeding available stock.
    if available_quantity <= 0
      redirect_back(
        fallback_location: product_path(product),
        alert: "#{product.name} is already at the maximum available quantity."
      )

      return
    end

    quantity_to_add = [ requested_quantity, available_quantity ].min

    cart[product.id.to_s] = current_quantity + quantity_to_add
    session[:cart] = cart

    if quantity_to_add < requested_quantity
      redirect_back(
        fallback_location: product_path(product),
        alert: "Only #{quantity_to_add} additional item(s) were available."
      )
    else
      redirect_back(
        fallback_location: product_path(product),
        notice: "#{product.name} was added to your cart."
      )
    end
  end

  def update
    product = Product.find(params[:product_id])

    # Removes items that are no longer available.
    if product.stock_quantity.zero?
      cart.delete(product.id.to_s)
      session[:cart] = cart

      redirect_to cart_path,
                  alert: "#{product.name} is out of stock and was removed."

      return
    end

    requested_quantity = normalized_quantity
    updated_quantity = [ requested_quantity, product.stock_quantity ].min

    cart[product.id.to_s] = updated_quantity
    session[:cart] = cart

    message =
      if updated_quantity < requested_quantity
        "Quantity was limited to the #{updated_quantity} item(s) available."
      else
        "#{product.name} quantity was updated."
      end

    redirect_to cart_path, notice: message
  end

  def destroy
    product = Product.find(params[:product_id])

    cart.delete(product.id.to_s)
    session[:cart] = cart

    redirect_to cart_path,
                notice: "#{product.name} was removed from your cart."
  end

  private

    # Converts missing, zero, or negative values to a minimum of one.
    def normalized_quantity
      [ params.fetch(:quantity, 1).to_i, 1 ].max
    end
end
