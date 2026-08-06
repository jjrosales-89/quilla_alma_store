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
end
