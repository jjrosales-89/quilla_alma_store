class Product < ApplicationRecord
  belongs_to :category

  has_many :product_tags,
           dependent: :destroy,
           inverse_of: :product

  has_many :tags, through: :product_tags

  validates :name,
            presence: true,
            length: { maximum: 120 }

  validates :description, presence: true

  validates :price,
            presence: true,
            numericality: { greater_than: 0 }

  validates :stock_quantity,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

  validates :sale_price,
            numericality: { greater_than: 0 },
            allow_nil: true

  validate :sale_price_requirements

  private

  def sale_price_requirements
    if on_sale? && sale_price.blank?
      errors.add(:sale_price, "must be provided when the product is on sale")
    end

    return if sale_price.blank? || price.blank?

    if sale_price >= price
      errors.add(:sale_price, "must be less than the regular price")
    end
  end
end
