class OrdersController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_order, only: :show

  def index
    @orders = current_customer.orders
                              .includes(:order_items)
                              .order(placed_at: :desc)
  end

  def show
  end

  private

  def set_order
    @order = current_customer.orders
                             .includes(order_items: :product)
                             .find(params[:id])
  end
end
