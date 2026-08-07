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

  validates :stripe_checkout_session_id,
            uniqueness: true,
            allow_nil: true

  validates :stripe_payment_intent_id,
            uniqueness: true,
            allow_nil: true

  def placed?
    placed_at.present?
  end

  def mark_as_paid!(payment_intent_id:)
    with_lock do
      return if paid_at.present?

      update!(
        status: "paid",
        stripe_payment_intent_id: payment_intent_id,
        paid_at: Time.current
      )
    end
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      created_at
      customer_email
      customer_id
      customer_name
      id
      paid_at
      placed_at
      province_code
      status
      stripe_checkout_session_id
      stripe_payment_intent_id
      subtotal
      total
      updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[customer order_items]
  end

end
