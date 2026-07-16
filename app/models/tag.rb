class Tag < ApplicationRecord
  has_many :product_tags,
           dependent: :destroy,
           inverse_of: :tag

  has_many :products, through: :product_tags

  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { maximum: 50 }
end
