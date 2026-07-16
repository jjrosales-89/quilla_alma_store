class Category < ApplicationRecord
  has_many :products,
           dependent: :restrict_with_error,
           inverse_of: :category

  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { maximum: 80 }

  validates :description,
            length: { maximum: 500 },
            allow_blank: true
end
