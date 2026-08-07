require "test_helper"

class StripeWebhooksControllerTest < ActionDispatch::IntegrationTest
  test "completed paid checkout marks order as paid" do
    order = orders(:manitoba_order)

    order.update!(
      stripe_checkout_session_id: "cs_test_paid"
    )

    checkout_session = Stripe::Checkout::Session.construct_from(
      id: "cs_test_paid",
      payment_status: "paid",
      payment_intent: "pi_test_paid"
    )

    event = Stripe::Event.construct_from(
      type: "checkout.session.completed",
      data: {
        object: checkout_session
      }
    )

    original_secret = ENV["STRIPE_WEBHOOK_SECRET"]
    ENV["STRIPE_WEBHOOK_SECRET"] = "test_webhook_secret"

    Stripe::Webhook.stub(:construct_event, event) do
      post stripe_webhook_url,
           params: "{}",
           headers: {
             "Stripe-Signature" => "test-signature",
             "Content-Type" => "application/json"
           }
    end

    assert_response :success

    order.reload

    assert_equal "paid", order.status
    assert_equal "pi_test_paid",
                 order.stripe_payment_intent_id
    assert_not_nil order.paid_at
  ensure
    ENV["STRIPE_WEBHOOK_SECRET"] = original_secret
  end

  test "unpaid checkout does not mark order as paid" do
    order = orders(:manitoba_order)

    order.update!(
      stripe_checkout_session_id: "cs_test_unpaid"
    )

    checkout_session = Stripe::Checkout::Session.construct_from(
      id: "cs_test_unpaid",
      payment_status: "unpaid",
      payment_intent: nil
    )

    event = Stripe::Event.construct_from(
      type: "checkout.session.completed",
      data: {
        object: checkout_session
      }
    )

    original_secret = ENV["STRIPE_WEBHOOK_SECRET"]
    ENV["STRIPE_WEBHOOK_SECRET"] = "test_webhook_secret"

    Stripe::Webhook.stub(:construct_event, event) do
      post stripe_webhook_url,
           params: "{}",
           headers: {
             "Stripe-Signature" => "test-signature",
             "Content-Type" => "application/json"
           }
    end

    assert_response :success
    assert_equal "pending", order.reload.status
  ensure
    ENV["STRIPE_WEBHOOK_SECRET"] = original_secret
  end
end
