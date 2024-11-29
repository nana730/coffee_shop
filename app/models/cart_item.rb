class CartItem < ApplicationRecord
  belongs_to :customer
  belongs_to :product

  enum bean_state: { "豆": 0, "粉": 1 }

  def subtotal
    product.price * quantity
  end
end
