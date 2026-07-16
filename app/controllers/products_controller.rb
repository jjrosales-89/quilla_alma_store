class ProductsController < ApplicationController
  def index
    # Load associations once for efficient product-card rendering.
    @products = Product.includes(:category, :tags).order(:name)
  end

  def show
    @product = Product.includes(:category, :tags).find(params[:id])
  end
end
