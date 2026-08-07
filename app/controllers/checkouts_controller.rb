class CheckoutsController < ApplicationController
  before_action :authenticate_customer!
  before_action :load_cart_items,
                only: %i[show create]

  def show
    redirect_to cart_path, alert: "Your cart is empty." if @cart_items.empty?
  end

  def create
    if @cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    order = build_order

    Order.transaction do
      order.save!
      create_order_items(order)
    end

    checkout_session = StripeCheckoutSessionCreator.new(
      order: order,
success_url: "#{checkout_success_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: checkout_cancel_url(
        order_id: order.id
      )
    ).call

    redirect_to checkout_session.url,
                allow_other_host: true,
                status: :see_other

  rescue ActiveRecord::RecordInvalid => error
    redirect_to checkout_path,
                alert: "Checkout could not be completed: #{error.record.errors.full_messages.to_sentence}"
  end

  def success
    checkout_session =
      Stripe::Checkout::Session.retrieve(params[:session_id])

    order = current_customer.orders.find_by!(
      stripe_checkout_session_id: checkout_session.id
    )

    if checkout_session.payment_status == "paid"
      order.mark_as_paid!(
        payment_intent_id: checkout_session.payment_intent.to_s
      )

      session[:cart] = {}

      redirect_to order_path(order),
                  notice: "Payment completed successfully."
    else
      redirect_to order_path(order),
                  alert: "Payment confirmation is still processing."
    end
  rescue ActiveRecord::RecordNotFound, Stripe::StripeError
    redirect_to orders_path,
                alert: "We could not verify the Stripe payment."
  end

  def cancel
    redirect_to checkout_path,
                alert: "Payment was cancelled. Your cart has not been changed."
  end

  private

  def load_cart_items
    product_ids = cart.keys
    products = Product.where(id: product_ids).index_by { |product| product.id.to_s }

    @cart_items = cart.filter_map do |product_id, quantity|
      product = products[product_id.to_s]
      next unless product

      {
        product: product,
        quantity: quantity.to_i,
        unit_price: product.current_price,
        line_total: product.current_price * quantity.to_i
      }
    end

    @subtotal = @cart_items.sum { |item| item[:line_total] }
    calculate_taxes
  end

  def calculate_taxes
    province = current_customer.province

    @gst_amount = (@subtotal * province.gst_rate).round(2)
    @pst_amount = (@subtotal * province.pst_rate).round(2)
    @hst_amount = (@subtotal * province.hst_rate).round(2)

    @total = @subtotal + @gst_amount + @pst_amount + @hst_amount
  end

  def build_order
    province = current_customer.province

    current_customer.orders.build(
      status: "pending",
      customer_name: current_customer.full_name,
      customer_email: current_customer.email,
      address_line_1: current_customer.address_line_1,
      address_line_2: current_customer.address_line_2,
      city: current_customer.city,
      province_name: province.name,
      province_code: province.code,
      postal_code: current_customer.postal_code,
      subtotal: @subtotal,
      gst_rate: province.gst_rate,
      pst_rate: province.pst_rate,
      hst_rate: province.hst_rate,
      gst_amount: @gst_amount,
      pst_amount: @pst_amount,
      hst_amount: @hst_amount,
      total: @total,
      placed_at: Time.current
    )
  end

  def create_order_items(order)
    @cart_items.each do |item|
      order.order_items.create!(
        product: item[:product],
        product_name: item[:product].name,
        unit_price: item[:unit_price],
        quantity: item[:quantity],
        line_total: item[:line_total]
      )
    end
  end
end
