class Product < ApplicationRecord
  validates :name, presence: true
   validates :description, presence: true
   validates :price, presence: true
   validates :stock, presence: true
   validates :image, presence: true
   has_one_attached :image

   scope :price_high_to_low, -> { order(price: :desc) }
   scope :price_low_to_high, -> { order(price: :asc) }
   scope :price_high_to_low, -> { order(price: :desc) }
   scope :taste_sort, ->(attribute) { order(attribute => :desc) }
   has_many :cart_items, dependent: :destroy
   has_many :order_items, dependent: :destroy
end
