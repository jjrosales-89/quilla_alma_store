class Province < ApplicationRecord
  has_many :customers,
           dependent: :restrict_with_error,
           inverse_of: :province

  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { maximum: 50 }

  validates :code,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: {
              with: /\A[A-Z]{2}\z/,
              message: "must contain two uppercase letters"
            }

  validates :gst_rate,
            :pst_rate,
            :hst_rate,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 1
            }
  def self.ransackable_attributes(_auth_object = nil)
    %w[
      code
      created_at
      gst_rate
      hst_rate
      id
      name
      pst_rate
      updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[customers]
  end
end
