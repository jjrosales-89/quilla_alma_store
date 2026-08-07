class StripeCheckoutSessionCreator
  def initialize(order:, success_url:, cancel_url:)
    @order = order
    @success_url = success_url
    @cancel_url = cancel_url
  end

  def call
    checkout_session = Stripe::Checkout::Session.create(
      mode: "payment",
      payment_method_types: ["card"],
      customer_email: @order.customer_email,
      client_reference_id: @order.id.to_s,
      metadata: {
        order_id: @order.id.to_s
      },
      payment_intent_data: {
        metadata: {
          order_id: @order.id.to_s
        }
      },
      line_items: line_items,
      success_url: @success_url,
      cancel_url: @cancel_url
    )

    @order.update!(
      stripe_checkout_session_id: checkout_session.id
    )

    checkout_session
  end

  private

  def line_items
    product_line_items + tax_line_items
  end

  def product_line_items
    @order.order_items.map do |item|
      {
        price_data: {
          currency: "cad",
          product_data: {
            name: item.product_name
          },
          unit_amount: cents(item.unit_price)
        },
        quantity: item.quantity
      }
    end
  end

  def tax_line_items
    [
      ["GST", @order.gst_amount],
      ["PST", @order.pst_amount],
      ["HST", @order.hst_amount]
    ].filter_map do |name, amount|
      next unless amount.positive?

      {
        price_data: {
          currency: "cad",
          product_data: {
            name: name
          },
          unit_amount: cents(amount)
        },
        quantity: 1
      }
    end
  end

  def cents(amount)
    (amount.to_d * 100).round.to_i
  end
end
