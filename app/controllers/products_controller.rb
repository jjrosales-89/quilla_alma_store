class ProductsController < ApplicationController
  def index
    @categories = Category.order(:name)

    @products = Product
      .includes(:category, :tags)
      .order(:name)

    if params[:query].present?
      search_term = Product.sanitize_sql_like(params[:query].strip)

      @products = @products.where(
        "products.name LIKE :term OR products.description LIKE :term",
        term: "%#{search_term}%"
      )
    end

    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    if params[:on_sale] == "1"
      @products = @products.where(on_sale: true)
    end

    @products = @products.page(params[:page]).per(8)
  end

  def show
    @product = Product.includes(:category, :tags).find(params[:id])
  end
end
