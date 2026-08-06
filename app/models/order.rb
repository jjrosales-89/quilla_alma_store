class Order < ApplicationRecord
  STATUSES = %w[pending paid processing shipped completed cancelled].freeze

  belongs_to :customer,
             inverse_of: :orders

  has_many :order_items,
           dependent: :destroy,
           inverse_of: :order

  validates :status,
            presence: true,
            inclusion: { in: STATUSES }

  validates :customer_name,
            :customer_email,
            :address_line_1,
            :city,
            :province_name,
            :province_code,
            :postal_code,
            presence: true

  validates :subtotal,
            :gst_rate,
            :pst_rate,
            :hst_rate,
            :gst_amount,
            :pst_amount,
            :hst_amount,
            :total,
            numericality: { greater_than_or_equal_to: 0 }

  def placed?
    placed_at.present?
  end
end
