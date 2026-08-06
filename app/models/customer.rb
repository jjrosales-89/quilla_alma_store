class Customer < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  belongs_to :province,
             inverse_of: :customers

  has_many :orders,
            dependent: :restrict_with_error,
            inverse_of: :customer

  validates :first_name,
            :last_name,
            :address_line_1,
            :city,
            :postal_code,
            presence: true

  validates :first_name,
            :last_name,
            length: { maximum: 50 }

  validates :address_line_1,
            :address_line_2,
            length: { maximum: 100 }

  validates :city,
            length: { maximum: 60 }

  validates :postal_code,
            format: {
              with: /\A[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d\z/,
              message: "must be a valid Canadian postal code"
            }

  validates :phone_number,
            length: { maximum: 25 },
            allow_blank: true

  before_validation :normalize_postal_code

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def normalize_postal_code
    return if postal_code.blank?

    self.postal_code = postal_code
                       .delete(" ")
                       .upcase
                       .insert(3, " ")
  end
end
