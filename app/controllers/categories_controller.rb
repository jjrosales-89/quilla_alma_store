class CategoriesController < ApplicationController
  def index
    @categories = Category.includes(:products).order(:name)
  end

  def show
    @category = Category.find(params[:id])

    @products = @category.products
      .includes(:category, :tags)
      .order(:name)
      .page(params[:page])
      .per(8)
  end
end
