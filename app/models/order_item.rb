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

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      created_at
      id
      line_total
      order_id
      product_id
      product_name
      quantity
      unit_price
      updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[order product]
  end
end
