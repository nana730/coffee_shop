class Article < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :image, presence: true
  has_one_attached :image
end
