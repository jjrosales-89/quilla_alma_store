class OrderItem < ApplicationRecord
  belongs_to :order,
             inverse_of: :order_items

  belongs_to :product,
             optional: true,
             inverse_of: :order_items

  validates :product_name,
            presence: true

  validates :unit_price,
            :line_total,
            numericality: { greater_than_or_equal_to: 0 }

  validates :quantity,
            numericality: {
              only_integer: true,
              greater_than: 0
            }
end
