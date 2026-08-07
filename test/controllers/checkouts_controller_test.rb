require "test_helper"

class CheckoutsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "guest is redirected to login from checkout" do
    get checkout_url

    assert_redirected_to new_customer_session_url
  end

  test "signed-in customer with an empty cart returns to cart" do
    sign_in customers(:demo_customer)

    get checkout_url

    assert_redirected_to cart_url
    assert_equal "Your cart is empty.", flash[:alert]
  end

  test "guest cannot submit checkout" do
    post checkout_url

    assert_redirected_to new_customer_session_url
  end

  test "signed-in customer cannot submit an empty cart" do
    sign_in customers(:demo_customer)

    post checkout_url

    assert_redirected_to cart_url
    assert_equal "Your cart is empty.", flash[:alert]
  end

test "successful Stripe return marks order paid and clears cart" do
  customer = customers(:demo_customer)
  product = products(:coffee)
  order = orders(:manitoba_order)

  sign_in customer

  post add_cart_item_url(product), params: { quantity: 1 }

  order.update!(
    stripe_checkout_session_id: "cs_test_success"
  )

  stripe_session = Stripe::Checkout::Session.construct_from(
    id: "cs_test_success",
    payment_status: "paid",
    payment_intent: "pi_test_success"
  )

  Stripe::Checkout::Session.stub(:retrieve, stripe_session) do
    get checkout_success_url(
      session_id: "cs_test_success"
    )
  end

  assert_redirected_to order_url(order)

  order.reload

  assert_equal "paid", order.status
  assert_equal "pi_test_success",
               order.stripe_payment_intent_id
  assert_not_nil order.paid_at

  get cart_url

  assert_response :success
  assert_select ".empty-cart"
end

  test "cancelled Stripe checkout preserves the cart" do
    customer = customers(:demo_customer)
    product = products(:coffee)

    sign_in customer

    post add_cart_item_url(product), params: { quantity: 1 }

    get checkout_cancel_url

    assert_redirected_to checkout_url
    assert_equal "Payment was cancelled. Your cart has not been changed.",
                flash[:alert]

    get cart_url

    assert_response :success
    assert_select ".cart-item", count: 1
  end
end
