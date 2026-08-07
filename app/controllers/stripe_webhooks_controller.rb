class StripeWebhooksController < ApplicationController
  skip_forgery_protection

  def create
    event = Stripe::Webhook.construct_event(
      request.raw_post,
      request.headers["Stripe-Signature"],
      ENV.fetch("STRIPE_WEBHOOK_SECRET")
    )

    handle_checkout_completed(event.data.object) \
      if event.type == "checkout.session.completed"

    head :ok
  rescue JSON::ParserError, Stripe::SignatureVerificationError
    head :bad_request
  end

  private

  def handle_checkout_completed(checkout_session)
    return unless checkout_session.payment_status == "paid"

    order = Order.find_by(
      stripe_checkout_session_id: checkout_session.id
    )

    return unless order

    order.mark_as_paid!(
      payment_intent_id: checkout_session.payment_intent.to_s
    )
  end
end
