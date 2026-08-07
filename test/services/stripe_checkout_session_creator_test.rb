require "test_helper"

class StripeCheckoutSessionCreatorTest < ActiveSupport::TestCase
  test "creates a Stripe session from historical order values" do
    order = orders(:manitoba_order)

    stripe_response = Struct.new(:id, :url).new(
      "cs_test_quilla_alma",
      "https://checkout.stripe.com/test"
    )

    captured_parameters = nil

    create_session = lambda do |parameters|
      captured_parameters = parameters
      stripe_response
    end

    Stripe::Checkout::Session.stub(:create, create_session) do
      result = StripeCheckoutSessionCreator.new(
        order: order,
        success_url: "http://example.com/checkout/success" \
                     "?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: "http://example.com/checkout/cancel"
      ).call

      assert_equal stripe_response, result
    end

    order.reload

    assert_equal "cs_test_quilla_alma",
                 order.stripe_checkout_session_id

    assert_equal "payment",
                 captured_parameters[:mode]

    assert_equal order.id.to_s,
                 captured_parameters[:client_reference_id]

    assert_equal order.id.to_s,
                 captured_parameters.dig(:metadata, :order_id)

    assert_equal order.customer_email,
                 captured_parameters[:customer_email]

    line_items = captured_parameters[:line_items]

    assert_equal 3, line_items.length

    product_line = line_items.first

    assert_equal "Test Ecuadorian Coffee",
                 product_line.dig(
                   :price_data,
                   :product_data,
                   :name
                 )

    assert_equal 1895,
                 product_line.dig(:price_data, :unit_amount)

    assert_equal 2, product_line[:quantity]

    assert_equal 190,
                 line_items.second.dig(
                   :price_data,
                   :unit_amount
                 )

    assert_equal 265,
                 line_items.third.dig(
                   :price_data,
                   :unit_amount
                 )
  end
end
