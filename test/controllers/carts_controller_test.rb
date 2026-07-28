require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  test "displays an empty shopping cart" do
    get cart_url

    assert_response :success
    assert_select "h1", "Shopping Cart"
    assert_select ".empty-cart"
    assert_select ".empty-cart h2", "Your cart is empty"
  end

  test "adds a product and quantity to the cart" do
    product = products(:coffee)

    post add_cart_item_url(product), params: { quantity: 2 }

    assert_redirected_to product_url(product)

    follow_redirect!

    assert_response :success
    assert_select ".flash--notice",
                  "#{product.name} was added to your cart."
    assert_select "nav a", text: "Cart (2)"

    # Confirms that the quantity remains available in a later request.
    get cart_url

    assert_response :success
    assert_select ".cart-item", count: 1
    assert_select ".cart-item h2", product.name
    assert_select "input[name='quantity'][value='2']"
  end

  test "combines repeated additions of the same product" do
    product = products(:coffee)

    post add_cart_item_url(product), params: { quantity: 1 }
    post add_cart_item_url(product), params: { quantity: 2 }

    get cart_url

    assert_response :success
    assert_select ".cart-item", count: 1
    assert_select "input[name='quantity'][value='3']"
    assert_select "nav a", text: "Cart (3)"
  end

  test "limits added quantities to available stock" do
    product = products(:throw)

    post add_cart_item_url(product), params: { quantity: 10 }

    assert_redirected_to product_url(product)

    follow_redirect!

    assert_select ".flash--alert",
                  "Only #{product.stock_quantity} additional item(s) were available."

    get cart_url

    assert_select "input[name='quantity'][value='4']"
    assert_select "nav a", text: "Cart (4)"
  end

  test "updates a product quantity" do
    product = products(:coffee)

    post add_cart_item_url(product), params: { quantity: 1 }

    patch update_cart_item_url(product), params: { quantity: 3 }

    assert_redirected_to cart_url

    follow_redirect!

    assert_response :success
    assert_select ".flash--notice",
                  "#{product.name} quantity was updated."
    assert_select "input[name='quantity'][value='3']"
    assert_select "nav a", text: "Cart (3)"
  end

  test "uses sale price when calculating the item subtotal" do
    product = products(:throw)

    post add_cart_item_url(product), params: { quantity: 2 }

    get cart_url

    assert_response :success
    assert_select ".cart-item", count: 1
    assert_select ".cart-item__details strong", text: "$84.00", count: 1
    assert_select ".cart-summary strong", text: "$84.00", count: 1
  end

  test "removes a product independently from the cart" do
    product = products(:coffee)

    post add_cart_item_url(product), params: { quantity: 2 }

    delete remove_cart_item_url(product)

    assert_redirected_to cart_url

    follow_redirect!

    assert_response :success
    assert_select ".flash--notice",
                  "#{product.name} was removed from your cart."
    assert_select ".cart-item", count: 0
    assert_select ".empty-cart"
    assert_select "nav a", text: "Cart (0)"
  end

  test "removes a product that becomes out of stock" do
    product = products(:coffee)

    post add_cart_item_url(product), params: { quantity: 1 }

    # Simulates an administrator changing the available stock.
    product.update_column(:stock_quantity, 0)

    patch update_cart_item_url(product), params: { quantity: 1 }

    assert_redirected_to cart_url

    follow_redirect!

    assert_select ".flash--alert",
                  "#{product.name} is out of stock and was removed."
    assert_select ".empty-cart"
    assert_select "nav a", text: "Cart (0)"
  end
end
