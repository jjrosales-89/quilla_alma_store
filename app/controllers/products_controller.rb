class ProductsController < ApplicationController
  def index
    # Load associations once and display eight products per page.
    @products = Product
      .includes(:category, :tags)
      .order(:name)
      .page(params[:page])
      .per(8)
  end

  def show
    @product = Product.includes(:category, :tags).find(params[:id])
  end
end
