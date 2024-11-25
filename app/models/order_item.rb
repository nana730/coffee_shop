class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  def subtotal
    product.price * quantity
  end
end
